using Amiasea.API.Evaluators;
using Amiasea.API.Intent;
using Amiasea.Intent;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Identity.Web;
using Wolverine;
using Wolverine.Http;

namespace Amiasea.API.Infrastructure;

public static class AmiaseaBuilder
{
    public static WebApplicationBuilder AddAmiaseaTheater(this WebApplicationBuilder builder)
    {
        builder.Services.AddWolverineHttp();

        builder.Services.AddHttpContextAccessor();

        //builder.Services.AddHostedService<StartupAttestations>();

        // 1. Setup the Signal Surface (Entra ID)
        // builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
        //     .AddMicrosoftIdentityWebApi(builder.Configuration.GetSection("AzureAd"));

        builder.Services.AddAuthorization(options =>
        {
            // Policy for humans using your regular UI endpoints
            options.AddPolicy("UserInterfaceAccess", policy =>
                policy.RequireAuthenticatedUser()
                    .RequireClaim("scp", "access_as_user")); // Expects user scope

            // Policy for your custom Go Terraform provider endpoints
            options.AddPolicy("TerraformPipelineAccess", policy =>
                policy.RequireAuthenticatedUser()
                    .RequireClaim("azp", "e5979a4b-0875-4f8c-9688-f9e10a6c7aaf")); // TODO: Expects your App Registration ID
        });

        // This could be used to provide a Singleton service that stores or caches continually updated contextual information about the attestation state of various capabilities. For example, it could be used to track which capabilities have been attested and their current status.
        //builder.Services.AddScoped<IAttestmentContext, AttestmentContext>();

        // 3. Setup Wolverine (The Engine)
        builder.Host.UseWolverine(opts =>
        {
            // We leave 'opts.Policies' alone here because that is for the Message Bus.
            // The Theater (HTTP) is configured during the 'Map' phase.
        });

        return builder;
    }

    public static WebApplication UseAmiaseaTheater(this WebApplication app)
    {
        //app.UseAuthentication();
        //app.UseAuthorization();

        app.Map("/healthz/attest/{*capabilityName}", async (
            string capabilityName,
            [FromQuery(Name = "signalSurfaces")] string[] signalSurfaces,
            CancellationToken cancellationToken) =>
        {
            string statusResult = await CapabilityAttestationService.AttestAsync(capabilityName, signalSurfaces, cancellationToken);

            // Wrap the string inside an object with a "status" property
            return Results.Ok(new { status = statusResult });
        });
        // .RequireAuthorization("TerraformPipelineAccess");

        // Map Wolverine Endpoints (The Stage)
        app.MapWolverineEndpoints(opts => {
            // Wolverine configuration rules continue below...
        });

        return app;
    }
}

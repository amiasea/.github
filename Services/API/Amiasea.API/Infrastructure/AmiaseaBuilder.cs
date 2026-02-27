using Amiasea.API.Evaluators;
using Amiasea.API.Intent;
using Amiasea.Intent;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
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

        // 1. Setup the Signal Surface (Entra ID)
        builder.Services.AddAuthentication(OpenIdConnectDefaults.AuthenticationScheme)
            .AddMicrosoftIdentityWebApp(builder.Configuration.GetSection("AzureAd"));

        builder.Services.AddAuthorization();

        // 2. Register the Sovereign Registry of Truth
        builder.Services.AddScoped<IAttestmentContext, AttestmentContext>();
        builder.Services.AddScoped<SovereignContext>();

        // 2. Register the Broadcaster as a Health Check
        builder.Services.AddHealthChecks()
            .AddCheck<HealthzBroadcaster>(
                "Sovereign_Coherence_Pulse",
                failureStatus: HealthStatus.Unhealthy, // Triggers 503 on failure
                tags: new[] { "kernel", "attestation" }
            );

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
        app.UseAuthentication();
        app.UseAuthorization();

        app.MapHealthChecks("/healthz/attest", new HealthCheckOptions
        {
            // This allows the HCL Read method to see the "VerifiedSignals" and "Pulse" data
            ResponseWriter = async (context, report) =>
            {
                context.Response.ContentType = "application/json";
                var json = System.Text.Json.JsonSerializer.Serialize(new
                {
                    status = report.Status.ToString(),
                    results = report.Entries.Select(e => new {
                        key = e.Key,
                        pulse = e.Value.Data.GetValueOrDefault("Pulse"),
                        data = e.Value.Data
                    })
                });
                await context.Response.WriteAsync(json);
            }
        });


        // Map Wolverine Endpoints (The Stage)
        app.MapWolverineEndpoints(opts =>
        {
            // THE FIX (CS0411): We weave the HTTP Policy HERE, where the 'Loom' is active.
            opts.AddPolicy<SovereignCircuitBreaker>();

            // THE FIX (CS1061): Wolverine doesn't use 'AddRoleRequirement' on the options.
            // It uses the standard ASP.NET Core Authorization under the hood 
            // once you call .RequireAuthorizeOnAll()
            opts.RequireAuthorizeOnAll();
        });

        return app;
    }
}

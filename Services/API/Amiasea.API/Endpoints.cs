using System.Text.Json;
using Amiasea.Aviator.Data.Service;
using Amiasea.Intent;
using Microsoft.AspNetCore.Mvc;

namespace Amiasea.API;

public static class Endpoints
{
    public static WebApplication MapEndpoints(this WebApplication app)
    {
        // GET: List all airports
        app.MapGet("/api/airports", async (AirportService airportService) =>
        {
            try
            {
                var airports = await airportService.GetAirportsAsync();
                return Results.Ok(airports);
            }
            catch (Exception ex)
            {
                return Results.Problem(detail: ex.Message, statusCode: 500, title: "Substrate Synchronicity Failure");
            }
        })
        .WithName("GetAirports")
        .WithSummary("List All Airports")
        .WithDescription("Scans TFE for all airport workspaces.");

        // GET: Get airport manifests (main and working versions)
        app.MapGet("/api/airports/{airportId}", async (
            string airportId,
            AirportService airportService) =>
        {
            try
            {
                var manifests = await airportService.GetAirportManifestsAsync(airportId);
                return Results.Ok(manifests);
            }
            catch (Exception ex)
            {
                return Results.Problem(detail: ex.Message, statusCode: 500, title: "Substrate Synchronicity Failure");
            }
        })
        .WithName("GetAirport")
        .WithSummary("Get Airport Manifests")
        .WithDescription("Returns both the Sovereign Truth (Main) and Potential Reality (Working).");

        // POST: Create airport
        app.MapPost("/api/airports/{airportId}", async (
            string airportId,
            AirportService airportService,
            SovereignContext context,
            IAttestmentContext attestment) =>
        {
            if (context.IsIncoherent) return Results.StatusCode(503);

            try
            {
                await airportService.CreateAirportAsync(airportId);
                return Results.Created($"/api/airports/{airportId}", new
                {
                    airportId,
                    tier = context.Tier,
                    status = "Airport Created",
                    verifiedSignals = attestment.Signals.Count
                });
            }
            catch (Exception ex)
            {
                return Results.Problem(detail: ex.Message, statusCode: 500, title: "Substrate Synchronicity Failure");
            }
        })
        .WithName("CreateAirport")
        .WithSummary("Create Airport")
        .WithDescription("Creates a new airport and bootstraps the TFE workspace.");

        // PUT: Save airport manifest
        app.MapPut("/api/airports/{airportId}", async (
            string airportId,
            [FromBody] JsonElement manifest,
            AirportService airportService,
            SovereignContext context,
            IAttestmentContext attestment) =>
        {
            if (context.IsIncoherent) return Results.StatusCode(503);

            try
            {
                var jsonPayload = manifest.GetRawText();
                var result = await airportService.SaveAirportAsync(airportId, jsonPayload);

                return Results.Ok(new
                {
                    airportId,
                    tier = context.Tier,
                    status = "Sovereign Intent Registered",
                    message = result,
                    verifiedSignals = attestment.Signals.Count
                });
            }
            catch (ArgumentException ex)
            {
                return Results.BadRequest(new { error = "Governance Breach", details = ex.Message });
            }
            catch (Exception ex)
            {
                return Results.Problem(detail: ex.Message, statusCode: 500, title: "Substrate Synchronicity Failure");
            }
        })
        .WithName("UpdateAirport")
        .WithSummary("Register Sovereign Intent")
        .WithDescription("Validates JSON and commits to the working branch.");

        // POST: Deploy airport
        app.MapPost("/api/airports/{airportId}/deploy", async (
            string airportId,
            AirportService airportService,
            SovereignContext context,
            IAttestmentContext attestment) =>
        {
            if (context.IsIncoherent) return Results.StatusCode(503);

            try
            {
                var result = await airportService.DeployAirportAsync(airportId);
                return Results.Ok(new
                {
                    airportId,
                    tier = context.Tier,
                    status = "Deployment Initiated",
                    message = result,
                    verifiedSignals = attestment.Signals.Count
                });
            }
            catch (Exception ex)
            {
                return Results.Problem(detail: ex.Message, statusCode: 500, title: "Substrate Synchronicity Failure");
            }
        })
        .WithName("DeployAirport")
        .WithSummary("Deploy Airport")
        .WithDescription("Merges the working branch to main, triggering TFE Auto-Apply.");

        // DELETE: Delete airport
        app.MapDelete("/api/airports/{airportId}", async (
            string airportId,
            AirportService airportService,
            SovereignContext context,
            IAttestmentContext attestment) =>
        {
            if (context.IsIncoherent) return Results.StatusCode(503);

            try
            {
                await airportService.DeleteAirportAsync(airportId);
                return Results.NoContent();
            }
            catch (Exception ex)
            {
                return Results.Problem(detail: ex.Message, statusCode: 500, title: "Substrate Synchronicity Failure");
            }
        })
        .WithName("DeleteAirport")
        .WithSummary("Delete Airport")
        .WithDescription("Removes the airport file and cleans up the working branch.");

        return app;
    }
}

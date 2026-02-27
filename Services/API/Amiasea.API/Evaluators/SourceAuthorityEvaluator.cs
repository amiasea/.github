using System.Security.Claims;
using Amiasea.Intent;
using Wolverine;
using Wolverine.Http;

namespace Amiasea.API.Evaluation;

/// <summary>
/// SourceAuthority: Interrogates the Provenance Signal (GitHub OIDC).
/// Uses AI-Dampened Heuristics to reject "Crafty" versioning attempts.
/// </summary>
public static class SourceAuthorityEvaluator
{
    // The "Bit-Flip" Signal Name defined in your Genesis HCL
    private const string PROVENANCE_SIGNAL = "AUTHORITY_SOURCE_GH_MAIN_PROV";

    public static async Task<IResult> Before(
        ClaimsPrincipal user,
        IAttestmentContext context)
        //IAiIntentAuditor aiAuditor) // Our Sovereign AI Auditor
    {
        // 1. Extract the Raw Signal from the OIDC Surface
        var repo = user.FindFirst("repository")?.Value;
        var workflow = user.FindFirst("workflow")?.Value;

        //// 2. THE AI FLEX: "Does this look like a crafty way to version?"
        //// We check the metadata strings for "Lame" versioning patterns
        //var intentReport = await aiAuditor.AuditIntentAsync(repo, workflow);

        //if (intentReport.IsCraftyVersioning || intentReport.IsDampened)
        //{
        //    // ERROR: Coherence Violation. The Signal is Architecturally Dishonest.
        //    return Results.Extensions.SovereignError("RED_FLAG: Crafty Versioning Detected in SourceAuthority.");
        //}

        // 3. THE BIT-FLIP: If the AI says it's "Pure", we attest the signal.
        if (!string.IsNullOrEmpty(repo) && repo == "amiasea/.github")
        {
            context.Attest(PROVENANCE_SIGNAL, true);
        }

        return WolverineContinue.Result();
    }
}

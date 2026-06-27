using System.Security.Claims;
using Amiasea.Intent;
using Wolverine.Http;

namespace Amiasea.API.Evaluation;

/// <summary>
/// SourceAuthority: Interrogates the Provenance Signal (GitHub OIDC).
/// </summary>
public static class SourceAuthorityEvaluator
{
    private const string PROVENANCE_SIGNAL = "AUTHORITY_SOURCE_GH_MAIN_PROV";

    // Handing over the CancellationToken as requested by the defense!
    public static async Task Before(
        ClaimsPrincipal user, 
        IAttestmentContext context, 
        CancellationToken cancellationToken = default)
    {
        cancellationToken.ThrowIfCancellationRequested();

        // 1. Extract the Raw Signal from the OIDC Surface
        var repo = user.FindFirst("repository")?.Value;
        var workflow = user.FindFirst("workflow")?.Value; // Kept in case you expand logic later

        if (!string.IsNullOrEmpty(repo) && repo == "amiasea/.github")
        {
            // This is where your future await Task.Delay() or GitHub API call will live!
            await Task.Yield(); // Placeholder for async operations, ensures we are truly async and can be cancelled

            context.Attest(PROVENANCE_SIGNAL, true);
        }
    }
}

using System.Security.Claims;
using Amiasea.API.Infrastructure;
using Amiasea.Intent;
using Wolverine;
using Wolverine.Http;

namespace Amiasea.API.Evaluators;

/// <summary>
/// ExecutionAuthority: Interrogates the Operational Signal (Terraform/HCP).
/// Ensures the 'Machine' context matches the Genesis HCL Manifest.
/// </summary>
public static class ExecutionAuthorityEvaluator
{
    // The Bit-Flip Signal Name for the Execution Plane
    private const string EXECUTION_SIGNAL = "AUTHORITY_EXECUTION_HCP_PROV";

    public static IResult Before(
        ClaimsPrincipal user,
        IAttestmentContext context,
        IConfiguration config)
    {
        // 1. Extract the "Machine" Evidence
        var workspace = user.FindFirst("terraform_workspace_id")?.Value;
        var expectedWorkspace = config["Amiasea:Execution:ExpectedWorkspace"];

        // 2. The Coherence Check: Is the runner in the right domain?
        if (string.IsNullOrEmpty(workspace) || workspace != expectedWorkspace)
        {
            // ERROR: The ExecutionAuthority is attempting to act outside its scope.
            return Results.Extensions.SovereignError("COHERENCE_FAILURE: Unauthorized Execution Context.");
        }

        // 3. THE BIT-FLIP: Attest the Execution Plane.
        context.Attest(EXECUTION_SIGNAL, true);

        return WolverineContinue.Result();
    }
}

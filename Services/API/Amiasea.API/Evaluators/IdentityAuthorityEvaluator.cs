using System.Security.Claims;
using Amiasea.API.Infrastructure;
using Amiasea.Intent;
using Wolverine.Http;

namespace Amiasea.API.Evaluators;

public static class IdentityAuthorityEvaluator
{
    private const string IDENTITY_SIGNAL = "AUTHORITY_IDENTITY_ENTRA_PROV";

    public static IResult Before(IAttestmentContext context, SovereignContext sovereign)
    {
        // Only check for Coherence (Is the Bio-Seed there?)
        if (sovereign.IsIncoherent)
        {
            return Results.Extensions.SovereignError("COHERENCE_FAILURE: Missing AviatorID.");
        }

        // The Tier is just data. We attest the signal is verified.
        context.Attest(IDENTITY_SIGNAL, true);

        return WolverineContinue.Result();
    }
}

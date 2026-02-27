using Amiasea.Intent;
using JasperFx;
using JasperFx.CodeGeneration;
using JasperFx.CodeGeneration.Frames;
using Wolverine.Http;

namespace Amiasea.API.Infrastructure;

/// <summary>
/// The Sovereign Circuit Breaker: Weaving the "Refusal to Witness" 
/// into the ASP.NET Core HTTP Pipeline.
/// </summary>
public class SovereignCircuitBreaker : IHttpPolicy
{
    // The Loom's Modern Signature: It needs the Rules and the Container to weave.
    public void Apply(IReadOnlyList<HttpChain> chains, GenerationRules rules, IServiceContainer container)
    {
        foreach (var chain in chains)
        {
            // Injecting the 'Before' method into the front of the Woven Pipeline
            chain.Middleware.Add(new MethodCall(typeof(SovereignCircuitBreaker), nameof(Before)));
        }
    }

    // Wolverine Static Code Generation calls this BEFORE the handler
    public static IResult Before(IAttestmentContext context)
    {
        // 1. The Kernel Coherence Check
        // If no signals are verified, we are in "Digital Purgatory"
        if (context.Signals.Values.All(v => !v))
        {
            // We use a standard Problem() result since 'SovereignIndeterminate' 
            // is a semantic name for our 503 logic.
            return Results.Problem(
                detail: "Kernel Purgatory: Missing Coherent Signals.",
                statusCode: StatusCodes.Status503ServiceUnavailable,
                title: "Sovereign Indeterminate"
            );
        }

        // Signal is coherent, the performance continues.
        return WolverineContinue.Result();
    }
}

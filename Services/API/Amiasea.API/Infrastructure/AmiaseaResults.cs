using Microsoft.AspNetCore.Http;

namespace Amiasea.API.Infrastructure;

/// <summary>
/// Sovereign Result Extensions: Defining the "Refusal to Witness" 
/// within the Microsoft IResultExtensions ecosystem.
/// </summary>
public static class AmiaseaResults
{
    // The "ERROR" Status: For Coherence Violations and Corrupt Signals
    public static IResult SovereignError(this IResultExtensions extensions, string detail)
    {
        return Results.Problem(
            detail: detail,
            statusCode: StatusCodes.Status400BadRequest,
            title: "Sovereign Coherence Violation"
        );
    }

    // The "INDETERMINATE" Status: For Kernel Purgatory / Unmapped States
    public static IResult SovereignIndeterminate(this IResultExtensions extensions, string detail, int statusCode = 503)
    {
        return Results.Problem(
            detail: detail,
            statusCode: statusCode,
            title: "Sovereign Indeterminate"
        );
    }
}

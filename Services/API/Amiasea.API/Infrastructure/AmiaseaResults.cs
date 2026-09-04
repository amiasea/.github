using Microsoft.AspNetCore.Http;

namespace Amiasea.API.Infrastructure;

/// <summary>
/// Institutive Result Extensions: Defining the "Refusal to Witness" 
/// within the Microsoft IResultExtensions ecosystem.
/// </summary>
public static class AmiaseaResults
{
    // The "ERROR" Status: For Coherence Violations and Corrupt Signals
    public static IResult InstitutiveError(this IResultExtensions extensions, string detail)
    {
        return Results.Problem(
            detail: detail,
            statusCode: StatusCodes.Status400BadRequest,
            title: "Institutive Coherence Violation"
        );
    }

    // The "INDETERMINATE" Status: For Kernel Purgatory / Unmapped States
    public static IResult InstitutiveIndeterminate(this IResultExtensions extensions, string detail, int statusCode = 503)
    {
        return Results.Problem(
            detail: detail,
            statusCode: statusCode,
            title: "Institutive Indeterminate"
        );
    }
}

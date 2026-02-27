using System.Security.Claims;
using Microsoft.AspNetCore.Http; // Add this

namespace Amiasea.Intent;

public record SovereignContext
{
    public string AviatorId { get; }
    public string Tier { get; }

    public SovereignContext(IHttpContextAccessor accessor)
    {
        var principal = accessor.HttpContext?.User;

        // Direct mapping from the HCL-defined Extension Property
        AviatorId = principal?.FindFirst("extension_AviatorID")?.Value ?? "INDETERMINATE";

        // Direct mapping from the App Role
        Tier = principal?.FindFirst(ClaimTypes.Role)?.Value ?? "UNAUTHORIZED";
    }

    public bool IsIncoherent => AviatorId == "INDETERMINATE";
}

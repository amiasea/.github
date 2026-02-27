using Microsoft.Extensions.Diagnostics.HealthChecks;
using Amiasea.Intent;

namespace Amiasea.API.Infrastructure;

/// <summary>
/// The Coherence Pulse: Broadacts the health of the Authority Plane.
/// If the HCL Manifest doesn't match the Live Signals, it emits an ERROR.
/// </summary>
public class HealthzBroadcaster : IHealthCheck
{
    private readonly IAttestmentContext _context;
    private readonly IConfiguration _config;

    public HealthzBroadcaster(IAttestmentContext context, IConfiguration config)
    {
        _context = context;
        _config = config;
    }

    public Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context,
        CancellationToken cancellationToken = default)
    {
        // 1. Get the Required Signals from the HCL-driven App Config
        var required = _config.GetSection("Amiasea:RequiredSignals").Get<string[]>()
                       ?? Array.Empty<string>();

        // 2. Evaluate Coherence (The Truth vs. The Manifest)
        if (_context.IsCoherent(required))
        {
            return Task.FromResult(HealthCheckResult.Healthy("Sovereign Coherence Maintained.", new Dictionary<string, object>
            {
                { "Pulse", "STABLE" },
                { "VerifiedSignals", _context.Signals.Count }
            }));
        }

        // 3. THE ERROR UNLOAD: 
        // We emit a Red Flag. This is where the ExecutionAuthority (Terraform)
        // sees that the Information Architecture is corrupt.
        return Task.FromResult(HealthCheckResult.Unhealthy("COHERENCE_VIOLATION: Substrate Mismatch.", null, new Dictionary<string, object>
        {
            { "Pulse", "ERROR" },
            { "MissingSignals", required.Where(s => !_context.Signals.ContainsKey(s)) }
        }));
    }
}

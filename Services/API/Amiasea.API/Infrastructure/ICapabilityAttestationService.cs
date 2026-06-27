namespace Amiasea.API.Infrastructure;

public static class CapabilityAttestationService
{
    public static Task<string> AttestAsync(string capabilityName, string[] signalSurfaces, CancellationToken cancellationToken)
    {
        return Task.FromResult("CAPABLE");
    }
}

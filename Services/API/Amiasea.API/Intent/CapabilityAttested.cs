namespace Amiasea.API.Intent;

public record CapabilityAttested(
    string ClaimedTier,    // What your Identity (HCL) says you are
    string AttestedTier,   // What the Airport (Math) allowed you to be
    string SignalSurface   // The proof used (GH_OIDC, YubiKey, etc.)
);

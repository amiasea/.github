namespace Amiasea.Intent;

/// <summary>
/// The Sovereign Scorecard: A stateless bit-flip registry for signal verification.
/// It tracks the "Coherence" of the Mesh without a persistent database.
/// </summary>
public interface IAttestmentContext
{
    IReadOnlyDictionary<string, bool> Signals { get; }

    // Attest a signal surface as verified
    void Attest(string signalName, bool isVerified);

    // Check if the required signals for a Capability are coherent
    bool IsCoherent(params string[] requiredSignals);
}

public class AttestmentContext : IAttestmentContext
{
    private readonly Dictionary<string, bool> _signals = new();
    private const int MinNameLength = 24;
    private const int MaxNameLength = 32;

    public IReadOnlyDictionary<string, bool> Signals => _signals;

    public void Attest(string signalName, bool isVerified)
    {
        // THE GOVERNANCE GUARDRAIL: Enforce name length to prevent "Lame" versioning/tagging
        if (signalName.Length < MinNameLength || signalName.Length > MaxNameLength)
        {
            throw new InvalidOperationException($"COHERENCE_ERROR: Signal '{signalName}' violates architectural constraints.");
        }

        _signals[signalName] = isVerified;
    }

    public bool IsCoherent(params string[] requiredSignals)
    {
        foreach (var sig in requiredSignals)
        {
            if (!_signals.TryGetValue(sig, out var verified) || !verified)
            {
                // If a required mapping is missing or false, it's a Red Flag.
                return false;
            }
        }
        return true;
    }
}

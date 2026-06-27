using System.Security.Claims;
using Amiasea.API.Evaluation;
using Amiasea.Intent;

namespace Amiasea.API.Infrastructure;

public class StartupAttestations : IHostedLifecycleService
{
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly ILogger<StartupAttestations> _logger;

    public StartupAttestations(IServiceScopeFactory scopeFactory, ILogger<StartupAttestations> logger)
    {
        _scopeFactory = scopeFactory;
        _logger = logger;
    }

    // 1. THE RESTRAINING ORDER: This executes BEFORE Kestrel turns on its listeners
    public async Task StartingAsync(CancellationToken cancellationToken)
    {
        _logger.LogInformation("⏳ Initiating blocking Sovereign Theater Attestation Sequence...");

        try
        {
            // Open our temporary court session to resolve scoped resources safely
            using var scope = _scopeFactory.CreateScope();
            var context = scope.ServiceProvider.GetRequiredService<SovereignContext>();
            var attestment = scope.ServiceProvider.GetRequiredService<IAttestmentContext>();

            _logger.LogDebug("Evaluating system coherence markers against Source Authority...");

            var startupUser = new ClaimsPrincipal(new ClaimsIdentity(new[] 
            {
                new Claim("repository", "amiasea/.github"),
                new Claim("workflow", "main")
            }));

            // THE MODERNISED PIPELINE: Pass the raw host token, but drop a strict WaitAsync curtain on it.
            // This drops heavy allocations and handles the timeout at the task tracking level!
            await SourceAuthorityEvaluator.Before(startupUser, attestment, cancellationToken)
                .WaitAsync(TimeSpan.FromSeconds(5), cancellationToken);

            _logger.LogInformation("✅ Attestations completed at startup. Signals: {Count}", attestment.Signals.Count);
        }
        // THE MODERN CATCH: WaitAsync naturally throws a TimeoutException if the 5 seconds run out
        catch (TimeoutException)
        {
            _logger.LogCritical("🛑 CRITICAL TIMEOUT: GitHub/SourceAuthority failed to respond within 5 seconds.");
            throw new TimeoutException("Sovereign Theater startup was aborted due to a network attestation timeout.");
        }
        // This catches if the cloud orchestrator or Ctrl+C explicitly cancels the boot process
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
            _logger.LogWarning("Sovereign Theater startup sequence was aborted by the host application environment.");
            throw;
        }
        catch (Exception ex)
        {
            _logger.LogCritical(ex, "🛑 CRITICAL MALFUNCTION: Sovereign Theater Attestation failed.");
            throw; // Hard crash the app before it opens bad ports to the public
        }
    }

    // 2. The standard startup hook (executes as the host starts up, after StartingAsync)
    public Task StartAsync(CancellationToken cancellationToken)
    {
        _logger.LogInformation("Sovereign Theater background worker is online.");
        return Task.CompletedTask;
    }

    // 3. Required boilerplate for the lifecycle interface
    public Task StartedAsync(CancellationToken cancellationToken) => Task.CompletedTask;
    public Task StoppingAsync(CancellationToken cancellationToken) => Task.CompletedTask;
    
    public Task StopAsync(CancellationToken cancellationToken)
    {
        _logger.LogInformation("Sovereign Theater Attestation service shutting down.");
        return Task.CompletedTask;
    }

    public Task StoppedAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}

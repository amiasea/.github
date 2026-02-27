using System.Net.Http.Json;
using System.Text.Json;
using Amiasea.Data.Service;
using Json.Schema;
using Octokit;

namespace Amiasea.Aviator.Data.Service;

public class AirportService(IGitHubClient github, IGitHubTokenProvider tokenProvider, HttpClient tfeHttpClient)
{
    private const string Owner = "amiasea";
    private const string Repo = ".github";
    private const string MainBranch = "main";
    private const string TfeOrg = "amiasea";

    private static readonly JsonSchema _airportSchema = JsonSchema.FromFile("airport_schema.json");

    /// <summary>
    /// THE SOVEREIGN STITCH: Ensures the GitHub client has a valid Installation Token 
    /// minted by the ISovereignSigner (KeyVault or Local PEM) before proceeding.
    /// </summary>
    private async Task EnsureAuthorized()
    {
        // You have to access Credentials through the Connection property
        if (github.Connection.Credentials == Credentials.Anonymous)
        {
            var token = await tokenProvider.GetTokenAsync();

            // This is the 'Sovereign' Arming of the client
            github.Connection.Credentials = new Credentials(token);
        }
    }

    /// <summary>
    /// GET: Lists all airports by scanning TFE for workspaces.
    /// </summary>
    public async Task<List<AirportSummary>> GetAirportsAsync()
    {
        // TFE Uses a different Auth mechanism (usually a static token), 
        // so we don't need EnsureAuthorized() here unless TFE is also Federated.
        var tfeResponse = await tfeHttpClient.GetAsync($"organizations/{TfeOrg}/workspaces");
        tfeResponse.EnsureSuccessStatusCode();

        var tfeData = await tfeResponse.Content.ReadFromJsonAsync<TfeWorkspaceResponse>();

        return tfeData?.Data
            .Where(w => w.Attributes.Name.StartsWith("airport-"))
            .Select(w => new AirportSummary
            {
                WorkspaceName = w.Attributes.Name,
                AirportId = w.Attributes.Name.Replace("airport-", "")
            }).ToList() ?? new List<AirportSummary>();
    }

    /// <summary>
    /// GET: Returns both the Sovereign Truth (Main) and the Potential Reality (Working).
    /// </summary>
    public async Task<AirportManifests> GetAirportManifestsAsync(string airportId)
    {
        await EnsureAuthorized();

        var path = $"airports/{airportId}.tf.json";
        var result = new AirportManifests();

        // 1. Fetch Main (Solid State)
        try
        {
            var mainContent = await github.Repository.Content.GetAllContentsByRef(Owner, Repo, path, MainBranch);
            result.MainVersion = mainContent.First().Content;
            result.MainSha = mainContent.First().Sha;
        }
        catch (NotFoundException) { }

        // 2. Fetch Working Branch (Gaseous State)
        var branchName = $"working-{airportId}";
        try
        {
            var workingContent = await github.Repository.Content.GetAllContentsByRef(Owner, Repo, path, branchName);
            result.WorkingVersion = workingContent.First().Content;
            result.WorkingSha = workingContent.First().Sha;
        }
        catch (NotFoundException)
        {
            result.WorkingVersion = result.MainVersion;
        }

        result.HasUnsavedChanges = result.MainSha != result.WorkingSha && result.WorkingSha != null;
        return result;
    }

    /// <summary>
    /// CREATE: Purges any existing ghost branch, forks main to working-[id], 
    /// and bootstraps the TFE workspace HCL for a fresh session.
    /// </summary>
    public async Task CreateAirportAsync(string airportId)
    {
        await EnsureAuthorized();

        var branchName = $"working-{airportId}";

        // 1. THE PURGE: Reset the drafting table by killing any existing branch.
        try
        {
            await github.Git.Reference.Delete(Owner, Repo, $"heads/{branchName}");
        }
        catch (NotFoundException)
        {
            /* Runway is already clear; first time landing for this ID. */
        }

        // 2. THE BIRTH: Get the current Truth from Main and manifest the new working branch.
        var mainRef = await github.Git.Reference.Get(Owner, Repo, $"heads/{MainBranch}");
        await github.Git.Reference.Create(Owner, Repo, new NewReference($"heads/{branchName}", mainRef.Object.Sha));

        // 3. THE BOOTSTRAP: Define the "Law" (TFE Workspace block) in the new branch.
        var path = $"airports/{airportId}.tf.json";
        var bootstrapHcl = new
        {
            terraform = new
            {
                cloud = new
                {
                    organization = TfeOrg,
                    workspaces = new { name = $"airport-{airportId}" }
                }
            },
            resource = new
            {
                amiasea_airport = new Dictionary<string, object>
                {
                    { airportId, new { } }
                }
            }
        };

        var json = JsonSerializer.Serialize(bootstrapHcl, new JsonSerializerOptions { WriteIndented = true });

        await github.Repository.Content.CreateFile(Owner, Repo, path,
            new CreateFileRequest($"Bootstrap: {airportId}", json, branchName));
    }

    /// <summary>
    /// SAVE: Validates JSON against schema and commits to working branch.
    /// </summary>
    public async Task<string> SaveAirportAsync(string airportId, string jsonPayload)
    {
        await EnsureAuthorized();
        ValidateSchema(jsonPayload);

        var branchName = $"working-{airportId}";
        var path = $"airports/{airportId}.tf.json";

        var contents = await github.Repository.Content.GetAllContentsByRef(Owner, Repo, path, branchName);
        var currentFile = contents.First();

        var result = await github.Repository.Content.UpdateFile(Owner, Repo, path,
            new UpdateFileRequest($"Sovereign Save: {airportId}", jsonPayload, currentFile.Sha, branchName));

        return "Terraform Validate: Success. HCL Grammar is Sovereign.";
    }

    /// <summary>
    /// DEPLOY: Merges the validated working branch to main (Triggering TFE Auto-Apply).
    /// </summary>
    public async Task<string> DeployAirportAsync(string airportId)
    {
        await EnsureAuthorized();

        var branchName = $"working-{airportId}";

        // 1. THE CONTRACT: Create a Pull Request to bridge the Draft to the Truth.
        var pullRequest = await github.Repository.PullRequest.Create(Owner, Repo,
            new NewPullRequest($"Sovereign Deployment: {airportId}", branchName, MainBranch));

        // 2. THE MERGE: The O-App (Librarian) signs the manifest into the Sovereign Law.
        var merge = await github.Repository.PullRequest.Merge(Owner, Repo, pullRequest.Number,
            new MergePullRequest());

        if (!merge.Merged)
        {
            throw new Exception($"Ceremony Failed: Merge Conflict for {airportId}.");
        }

        return "Deployment Merged. TFE Reality Shift (Auto-Apply) in progress...";
    }

    /// <summary>
    /// DELETE: Removes file from working branch and merges to main and cleans up the branch.
    /// </summary>
    public async Task DeleteAirportAsync(string airportId)
    {
        await EnsureAuthorized();

        var branchName = $"working-{airportId}";
        var path = $"airports/{airportId}.tf.json";

        // 1. Get the file's current SHA from the specific branch
        var contents = await github.Repository.Content.GetAllContentsByRef(Owner, Repo, path, branchName);
        var fileSha = contents.First().Sha;

        // 2. Delete the file on the working branch
        // Note: DeleteFileRequest requires (message, sha, branch) to target the correct ref
        await github.Repository.Content.DeleteFile(Owner, Repo, path, new DeleteFileRequest($"Delete: {airportId}", fileSha, branchName));

        // 3. Create the Pull Request using NewPullRequest (Title, Head, Base)
        var pullRequestRequest = new NewPullRequest($"Delete: {airportId}", branchName, MainBranch);
        var pr = await github.Repository.PullRequest.Create(Owner, Repo, pullRequestRequest);

        // 4. Merge the PR
        await github.Repository.PullRequest.Merge(Owner, Repo, pr.Number, new MergePullRequest());

        // 5. Clean up the branch
        await github.Git.Reference.Delete(Owner, Repo, $"heads/{branchName}");
    }

    private void ValidateSchema(string jsonPayload)
    {
        using var doc = JsonDocument.Parse(jsonPayload);
        var evaluation = _airportSchema.Evaluate(doc.RootElement, new EvaluationOptions { OutputFormat = OutputFormat.Hierarchical });

        if (!evaluation.IsValid)
        {
            var errors = evaluation.Errors?.SelectMany(kvp => kvp.Value.Select(e => e.ToString())) ?? new List<string>();
            throw new ArgumentException($"Governance Breach: {string.Join(" | ", errors)}");
        }
    }

    // --- DTOs ---
    public class AirportSummary { public string AirportId { get; set; } = null!; public string WorkspaceName { get; set; } = null!; }
    public class AirportManifests { public string? MainVersion { get; set; } public string? MainSha { get; set; } public string? WorkingVersion { get; set; } public string? WorkingSha { get; set; } public bool HasUnsavedChanges { get; set; } }
    private class TfeWorkspaceResponse { public List<TfeWorkspaceData> Data { get; set; } = new(); }
    private class TfeWorkspaceData { public TfeAttributes Attributes { get; set; } = new(); }
    private class TfeAttributes { public string Name { get; set; } = null!; }
}
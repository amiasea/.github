using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Serialization;

namespace Amiasea.Data.Service;

public static class GitHubTokenExchanger
{
    private static readonly HttpClient _httpClient = new();

    public static async Task<string> ExchangeAsync(string jwt, string installationId)
    {
        var request = new HttpRequestMessage(HttpMethod.Post,
            $"https://api.github.com{installationId}/access_tokens");

        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", jwt);
        request.Headers.UserAgent.Add(new ProductInfoHeaderValue("amiasea-api", "1.0"));

        var response = await _httpClient.SendAsync(request);
        response.EnsureSuccessStatusCode();

        var result = await response.Content.ReadFromJsonAsync<GitHubTokenResponse>();
        return result?.Token ?? throw new Exception("GitHub Assertion failed to return a Token.");
    }

    private record GitHubTokenResponse([property: JsonPropertyName("token")] string Token);
}

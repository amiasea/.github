using System.Text;
using System.Text.Json;

namespace Amiasea.Data.Service;

public static class GitHubJwtFactory
{
    public static async Task<string> CreateAsync(string appId, ISovereignSigner signer)
    {
        var now = DateTimeOffset.UtcNow;
        var header = new { alg = "RS256", typ = "JWT" };
        var payload = new Dictionary<string, object>
        {
            { "iat", now.ToUnixTimeSeconds() - 60 }, // 60s buffer for clock drift
            { "exp", now.AddMinutes(9).ToUnixTimeSeconds() }, // 10 min max
            { "iss", appId }
        };

        string headerEncoded = Base64UrlEncode(JsonSerializer.SerializeToUtf8Bytes(header));
        string payloadEncoded = Base64UrlEncode(JsonSerializer.SerializeToUtf8Bytes(payload));
        string unsignedToken = $"{headerEncoded}.{payloadEncoded}";

        // The HSM or Local PEM performs the RS256 signature here
        byte[] signatureBytes = await signer.SignDataAsync(Encoding.UTF8.GetBytes(unsignedToken));

        return $"{unsignedToken}.{Base64UrlEncode(signatureBytes)}";
    }

    private static string Base64UrlEncode(byte[] input) =>
        Convert.ToBase64String(input).Replace("+", "-").Replace("/", "_").TrimEnd('=');
}

using Newtonsoft.Json;

namespace Amiasea.Data.Document;

public abstract class SovereignDocument
{
    [JsonProperty("id")]
    public string Id { get; set; } = Guid.NewGuid().ToString();

    [JsonProperty("type")]
    public abstract string Type { get; }

    [JsonProperty("ttl", NullValueHandling = NullValueHandling.Ignore)]
    public int? Ttl { get; set; }
}

using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Data.Document;

public class ActorDocument : SovereignDocument
{
    public override string Type => "actor";

    public string ExternalSubjectId { get; set; } // The Entra 'oid'
    public string ExternalProvider { get; set; } = "MicrosoftEntra";

    public string Role { get; set; } // e.g., "Sovereign", "Admin"
    public string DisplayName { get; set; }
    public string Email { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}

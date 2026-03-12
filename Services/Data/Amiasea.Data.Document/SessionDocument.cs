using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Data.Document;

public class SessionDocument : SovereignDocument
{
    public override string Type => "session";

    public string ActorId { get; set; } // Link to ActorDocument.Id
    public string EntraOid { get; set; }
    public string UserAgent { get; set; }
    public string IpAddress { get; set; }
    public DateTime AuthenticatedAt { get; set; } = DateTime.UtcNow;
}

using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Data.Document;

public class ActionDocument : SovereignDocument
{
    public override string Type => "action";

    // Example Id: "vault:create"
    public string Description { get; set; }

    // The roles allowed to perform this specific action
    public List<string> PermittedRoles { get; set; } = new();
}

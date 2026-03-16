using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Data.Entity.Authz;

public class Attestation
{
    public int ActorID { get; set; }
    public int ClaimID { get; set; }
    public string Value { get; set; }
}

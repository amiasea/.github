using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Data.Entity.Authz;

public class Role
{
    public int ID { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
    public IList<Entitlement> Entitlements { get; set; }
}

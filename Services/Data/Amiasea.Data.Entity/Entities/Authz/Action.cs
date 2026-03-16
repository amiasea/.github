using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Data.Entity.Authz;

public class Action
{
    public int ID { get; set; }
    public int ResourceID { get; set; }
    public Resource Resource { get; set;  }
    public Tier Tier { get; set; }
    public string Name { get; set; }
}

using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Data.Entity.Authz;

public class Organization
{
    public int ID { get; set; }
    public string Name { get; set; }
    public string Email { get; set; }
    public string Phone { get; set; }
    public string Domain { get; set; }
    public Tier Tier { get; set; }
}

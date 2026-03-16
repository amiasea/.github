using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Data.Entity.Authz;

public class Actor
{
    public int ID { get; set; }
    public string Name { get; set; }
    public string Email { get; set; }
    public int OrganizationID { get; set; }
    public Organization Organization { get; set; }
}

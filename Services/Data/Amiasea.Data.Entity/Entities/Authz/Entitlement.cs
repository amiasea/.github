using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Data.Entity.Authz;

public class Entitlement
{
    public int RoleID { get; set; }
    public int ActionID { get; set; }
}
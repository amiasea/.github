using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Data.Entity.Authz;

public class Grant
{
    public int ActorID { get; set; }
    public int RoleID { get; set; }
}
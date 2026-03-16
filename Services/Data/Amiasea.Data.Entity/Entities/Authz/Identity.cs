using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Data.Entity.Authz;

public class Identity
{
    public int ID { get; set; }
    public int ActorID { get; set; }
    public int AuthorityID { get; set; }
    public string AuthorityIdentitfier { get; set; }
}
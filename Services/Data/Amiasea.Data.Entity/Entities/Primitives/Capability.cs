using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Aviator.Data.Entity;

public class Capability
{
    public int ID { get; set; }
    public int? ParentID { get; set; }
    public int PlaneID { get; set; }
    public Plane Plane { get; set; }
    public string Name { get; set; } = string.Empty;
}

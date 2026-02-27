using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Aviator.Data.Entity;

public class Plane
{
    public int ID { get; set; }
    public int AirportID { get; set; }
    public Airport Airport { get; set; }
    public PlaneEnum Type { get; set; }
    public IList<Capability> Capabilities { get; set; } = new List<Capability>();
}

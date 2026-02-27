using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Aviator.Data.Entity;

public class Airport
{
    public int ID { get; set; }
    public string Name { get; set; }

    public IList<Plane> Planes { get; set; } = new List<Plane>();
}
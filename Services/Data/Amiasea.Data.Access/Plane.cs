using System;
using System.Collections.Generic;
using System.Text;
using Amiasea.Aviator.Data.Entity;

namespace Amiasea.Aviator.Data.Access;

public record Plane(int ID, int AirportID, string Repository, string Hangar, PlaneEnum Type);
using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Aviator.Data.Access;

public record Airport(int ID, string Name, Plane[] Planes);
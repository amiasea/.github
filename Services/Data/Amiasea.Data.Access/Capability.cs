using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Aviator.Data.Access;

public record Capability(int ID, int PlaneID, string Name, CapabilityStatusEnum Status);
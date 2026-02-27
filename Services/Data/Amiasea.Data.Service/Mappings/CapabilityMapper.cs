using Amiasea.Aviator.Data.Access;
using AutoMapper;

using E = Amiasea.Aviator.Data.Entity;

namespace Amiasea.Aviator.Data.Service.Mappings;

public class CapabilityMapper : Profile
{
    public CapabilityMapper()
    {
        CreateMap<E.Capability, Capability>()
            .ForMember(dest => dest.Status, opt => opt.Ignore());
        CreateMap<Capability, E.Capability>();
    }
}

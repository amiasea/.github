using Amiasea.Aviator.Data.Access;
using AutoMapper;

using E = Amiasea.Aviator.Data.Entity;

namespace Amiasea.Aviator.Data.Service.Mappings;

public class PlaneMapper : Profile
{
    public PlaneMapper()
    {
        CreateMap<E.Plane, Plane>();
        CreateMap<Plane, E.Plane>();
    }
}

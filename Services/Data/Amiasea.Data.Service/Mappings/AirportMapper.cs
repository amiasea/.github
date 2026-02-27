using Amiasea.Aviator.Data.Access;
using AutoMapper;

using E = Amiasea.Aviator.Data.Entity;

namespace Amiasea.Aviator.Data.Service.Mappings;

public class AirportMapper : Profile
{
    public AirportMapper()
    {
        CreateMap<E.Airport, Airport>();
        CreateMap<Airport, E.Airport>();
    }
}

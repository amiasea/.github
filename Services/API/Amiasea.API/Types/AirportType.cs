namespace Amiasea.Aviator.API.Types;

using Amiasea.Aviator.API.Types.DataLoaders;
using Amiasea.Aviator.Data.Access;
using AutoMapper;
using HotChocolate.Types;

public class AirportType : ObjectType<Airport>
{
    protected override void Configure(IObjectTypeDescriptor<Airport> descriptor)
    {
        descriptor.Field(a => a.ID).Type<NonNullType<IntType>>();
        descriptor.Field(a => a.Name).Type<StringType>();
        descriptor.Field(a => a.Planes).Type<ListType<PlaneType>>();

        descriptor.Field("planes")
            .UsePaging<PlaneType>()
            .Resolve(async ctx =>
            {
                var mapper = ctx.Service<IMapper>();
                var airport = ctx.Parent<Airport>();
                var loader = ctx.DataLoader<PlanesByAirportIdDataLoader>();
                var entities = await loader.LoadAsync(airport.ID, ctx.RequestAborted);
                return entities != null ? entities.Select(e => mapper.Map<Plane>(e)) : Array.Empty<Plane>();
            });
    }
}
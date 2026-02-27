namespace Amiasea.Aviator.API.Types;

using Amiasea.Aviator.API.Types.DataLoaders;
using Amiasea.Aviator.Data.Access;
using E = Amiasea.Aviator.Data.Entity;
using HotChocolate.Types;

public class PlaneType : ObjectType<Plane>
{
    protected override void Configure(IObjectTypeDescriptor<Plane> descriptor)
    {
        descriptor.Field(p => p.ID).Type<NonNullType<IntType>>();
        descriptor.Field(p => p.AirportID).Type<NonNullType<IntType>>();
        descriptor.Field(p => p.Type).Type<EnumType<E.PlaneEnum>>();
        descriptor.Field(p => p.Repository).Type<StringType>();
        descriptor.Field(p => p.Hangar).Type<StringType>();

        descriptor.Field("capabilities")
            .UsePaging<ObjectType<Capability>>()
            .Resolve(async ctx =>
            {
                var plane = ctx.Parent<Plane>();
                var loader = ctx.DataLoader<CapabilitiesByPlaneIdDataLoader>();
                return await loader.LoadAsync(plane.ID, ctx.RequestAborted);
            });
    }
}
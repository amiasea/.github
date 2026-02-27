using Amiasea.Aviator.Data.Access;
using HotChocolate.Types;

namespace Amiasea.Aviator.API.Types;

public class CapabilityType : ObjectType<Capability>
{
    protected override void Configure(IObjectTypeDescriptor<Capability> descriptor)
    {
        descriptor.Field(c => c.ID).Type<NonNullType<IntType>>();
        descriptor.Field(c => c.PlaneID).Type<NonNullType<IntType>>();
        descriptor.Field(c => c.Name).Type<StringType>();
        
        descriptor.Field("status")
            .Resolve(ctx =>
            {
                // Dynamically resolve status based on business logic
                var capability = ctx.Parent<Capability>();

                
                // Implement your status resolution logic here
                return CapabilityStatusEnum.CAPABLE; // placeholder
            });
    }
}

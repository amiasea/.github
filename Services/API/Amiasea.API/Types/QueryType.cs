namespace Amiasea.Aviator.API.Types;

using System.Threading;
using System.Threading.Tasks;
using Amiasea.Aviator.API.Types.DataLoaders;
using Amiasea.Aviator.Data.Access;
using E = Amiasea.Aviator.Data.Entity;
using AutoMapper;
using HotChocolate.Types;
using Microsoft.EntityFrameworkCore;

public class QueryType : ObjectType
{
    //private readonly IDbContextFactory<Context> _dbFactory;

    public QueryType() {}

    protected override void Configure(IObjectTypeDescriptor descriptor)
    {
        descriptor.Name("Query");

        // airports: [Airport!]!
        descriptor.Field("airports")
             .UsePaging()
             .UseFiltering()
             .Resolve(ctx =>
             {
                 var mapper = ctx.Service<IMapper>();
                 var db = ctx.Service<E.Context>();
                 var airports = db.Airports.Include(a => a.Planes);

                 return airports.ToList().Select(a => mapper.Map<Airport>(a));
             });

        // planes: [Plane!]!
        descriptor.Field("planes")
            .UsePaging<PlaneType>()            // explicit element type
            .Resolve(ctx =>
            {
                var mapper = ctx.Service<IMapper>();
                var db = ctx.Service<E.Context>();
                return db.Planes.Select(p => mapper.Map<Plane>(p));
            });
    }
}
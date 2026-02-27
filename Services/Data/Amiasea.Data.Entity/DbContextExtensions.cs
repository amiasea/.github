using Microsoft.EntityFrameworkCore;
using System.Linq;

public static class DbContextExtensions
{
    public static IQueryable Set(this DbContext db, Type entityType)
    {
        // DbContext has a non-generic Set(Type) method in EF Core 7/8/9/10
        var method = typeof(DbContext)
            .GetMethod(nameof(DbContext.Set), new[] { typeof(Type) });

        return (IQueryable)method!.Invoke(db, new object[] { entityType })!;
    }
}
namespace Amiasea.Aviator.API.Types.DataLoaders;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using GreenDonut;
using Microsoft.EntityFrameworkCore;
using Amiasea.Aviator.Data.Entity;

public sealed class PlanesByAirportIdDataLoader : BatchDataLoader<int, Plane[]>
{
    private readonly IDbContextFactory<Context> _dbFactory;

    public PlanesByAirportIdDataLoader(IBatchScheduler scheduler, IDbContextFactory<Context> dbFactory)
        : base(scheduler, new DataLoaderOptions())
    {
        _dbFactory = dbFactory ?? throw new ArgumentNullException(nameof(dbFactory));
    }

    protected override async Task<IReadOnlyDictionary<int, Plane[]>> LoadBatchAsync(
        IReadOnlyList<int> keys,
        CancellationToken cancellationToken)
    {
        if (keys == null || keys.Count == 0)
            return new Dictionary<int, Plane[]>();

        await using var db = _dbFactory.CreateDbContext();

        var planes = await db.Set<Plane>()
            .Include(p => p.Airport)
                .ThenInclude(a => a.Planes)
            //.AsNoTracking()
            .Where(p => keys.Contains(p.AirportID))
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);

        var map = planes
            .GroupBy(p => p.AirportID)
            .ToDictionary(g => g.Key, g => g.ToArray());

        foreach (var k in keys)
            if (!map.ContainsKey(k))
                map[k] = Array.Empty<Plane>();

        return map;
    }
}
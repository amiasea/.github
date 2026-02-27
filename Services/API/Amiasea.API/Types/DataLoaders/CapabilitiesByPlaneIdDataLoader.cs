namespace Amiasea.Aviator.API.Types.DataLoaders;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using GreenDonut;
using Microsoft.EntityFrameworkCore;
using Amiasea.Aviator.Data.Entity;

public sealed class CapabilitiesByPlaneIdDataLoader : BatchDataLoader<int, Capability[]>
{
    private readonly IDbContextFactory<Context> _dbFactory;

    public CapabilitiesByPlaneIdDataLoader(IBatchScheduler scheduler, IDbContextFactory<Context> dbFactory)
        : base(scheduler, new DataLoaderOptions())
    {
        _dbFactory = dbFactory ?? throw new ArgumentNullException(nameof(dbFactory));
    }

    protected override async Task<IReadOnlyDictionary<int, Capability[]>> LoadBatchAsync(
        IReadOnlyList<int> keys,
        CancellationToken cancellationToken)
    {
        if (keys == null || keys.Count == 0)
            return new Dictionary<int, Capability[]>();

        await using var db = _dbFactory.CreateDbContext();

        var items = await db.Set<Capability>()
            .AsNoTracking()
            .Where(c => keys.Contains(c.PlaneID))
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);

        var map = items
            .GroupBy(c => c.PlaneID)
            .ToDictionary(g => g.Key, g => g.ToArray());

        foreach (var k in keys)
            if (!map.ContainsKey(k))
                map[k] = Array.Empty<Capability>();

        return map;
    }
}
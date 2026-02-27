using E = Amiasea.Aviator.Data.Entity;
using Amiasea.Aviator.Data.Access;
using AutoMapper;
using Microsoft.EntityFrameworkCore;

namespace Amiasea.Aviator.API.Types;

public class MutationType
{
    private readonly IDbContextFactory<E.Context> _dbFactory;
    private readonly IMapper _mapper;

    public MutationType(IDbContextFactory<E.Context> dbFactory, IMapper mapper)
    {
        _dbFactory = dbFactory;
        _mapper = mapper;
    }

    // Create Airport: createAirport(name: String!): Airport
    public async Task<Airport> CreateAirportAsync(Airport airport, CancellationToken cancellationToken = default)
    {
        await using var db = _dbFactory.CreateDbContext();
        var newAirport = _mapper.Map<E.Airport>(airport);
        db.Airports.Add(newAirport);
        await db.SaveChangesAsync(cancellationToken);
        var result = await db.Airports.Include(a => a.Planes).SingleAsync(a => a.ID == newAirport.ID, cancellationToken);
        return _mapper.Map<Airport>(result);
    }

    // Update Airport: updateAirport(id: Int!, name: String): Airport
    public async Task<Airport?> UpdateAirportAsync(Airport airport, CancellationToken cancellationToken = default)
    {
        await using var db = _dbFactory.CreateDbContext();
        var existingAirport = await db.Airports.Include(a => a.Planes).SingleAsync(a => a.ID == airport.ID, cancellationToken);

        existingAirport.Name = airport.Name;

        // Get the types from the incoming planes
        var incomingPlaneTypes = airport.Planes.Select(p => p.Type).ToHashSet();

        // Remove planes whose Type is not in the incoming data
        var planesToRemove = existingAirport.Planes
            .Where(p => !incomingPlaneTypes.Contains(p.Type))
            .ToList();
        
        foreach (var plane in planesToRemove)
        {
            existingAirport.Planes.Remove(plane);
            db.Planes.Remove(plane);
        }

        // Update or add planes from incoming data
        foreach (var plane in airport.Planes)
        {
            var existingPlane = existingAirport.Planes.FirstOrDefault(p => p.Type == plane.Type);
            if (existingPlane != null)
            {
                // Update existing plane fields
            }
            else
            {
                // Add new plane
                var newPlane = _mapper.Map<E.Plane>(plane);
                newPlane.AirportID = existingAirport.ID;
                existingAirport.Planes.Add(newPlane);
            }
        }

        await db.SaveChangesAsync(cancellationToken);
        return _mapper.Map<Airport>(existingAirport);
    }

    // Delete Airport: deleteAirport(id: Int!): Boolean
    public async Task<bool> DeleteAirportAsync(int id, CancellationToken cancellationToken = default)
    {
        await using var db = _dbFactory.CreateDbContext();

        var airport = await db.Airports.Include(a => a.Planes).FirstOrDefaultAsync(a => a.ID == id, cancellationToken);
        if (airport == null) return false;

        // If you want cascade delete behavior, ensure EF config or remove related entities explicitly
        db.Planes.RemoveRange(airport.Planes);
        db.Airports.Remove(airport);
        await db.SaveChangesAsync(cancellationToken);
        return true;
    }

    // Create Plane: createPlane(airportID: Int!, type: PlaneEnum, repository: String, hangar: String): Plane
    public async Task<Plane?> CreatePlaneAsync(
        int airportID,
        E.PlaneEnum type,
        string? repository = null,
        string? hangar = null,
        CancellationToken cancellationToken = default)
    {
        await using var db = _dbFactory.CreateDbContext();
        var airportExists = await db.Airports.AnyAsync(a => a.ID == airportID, cancellationToken);
        if (!airportExists) return null;

        var plane = new Amiasea.Aviator.Data.Entity.Plane
        {
            AirportID = airportID,
            Type = type
        };

        db.Planes.Add(plane);
        await db.SaveChangesAsync(cancellationToken);
        plane = await db.Planes.SingleAsync(p => p.ID == plane.ID, cancellationToken);
        return _mapper.Map<Amiasea.Aviator.Data.Access.Plane>(plane);
    }

    //// Update Plane: updatePlane(id: Int!, airportID: Int, type: PlaneEnum, repository: String, hangar: String): Plane
    //public async Task<Amiasea.Aviator.Data.Access.Plane?> UpdatePlaneAsync(
    //    int id,
    //    int? airportID = null,
    //    PlaneEnum? type = null,
    //    string? repository = null,
    //    string? hangar = null,
    //    CancellationToken cancellationToken = default)
    //{
    //    await using var db = _dbFactory.CreateDbContext();
    //    var plane = await db.Planes.Include(p => p.Airport).ThenInclude(a => a.Planes).FirstOrDefaultAsync(p => p.ID == id, cancellationToken);
    //    if (plane == null) return null;

    //    if (airportID.HasValue) plane.AirportID = airportID.Value;
    //    if (type.HasValue) plane.Type = type.Value;
    //    if (repository is not null) plane.Repository = repository;
    //    if (hangar is not null) plane.Hangar = hangar;

    //    await db.SaveChangesAsync(cancellationToken);
    //    return _mapper.Map<Amiasea.Aviator.Data.Access.Plane>(plane);
    //}

    //// Delete Plane: deletePlane(id: Int!): Boolean
    //public async Task<bool> DeletePlaneAsync(int id, CancellationToken cancellationToken = default)
    //{
    //    await using var db = _dbFactory.CreateDbContext();
    //    var plane = await db.Planes.FindAsync(new object[] { id }, cancellationToken);
    //    if (plane == null) return false;
    //    db.Planes.Remove(plane);
    //    await db.SaveChangesAsync(cancellationToken);
    //    return true;
    //}

    //// Create Capability: createCapability(planeID: Int!, name: String!): Capability
    //public async Task<Capability?> CreateCapabilityAsync(int planeID, string name, CancellationToken cancellationToken = default)
    //{
    //    await using var db = _dbFactory.CreateDbContext();
    //    var planeExists = await db.Planes.AnyAsync(p => p.ID == planeID, cancellationToken);
    //    if (!planeExists) return null;

    //    var cap = new Capability { PlaneID = planeID, Name = name };
    //    db.Capabilities.Add(cap);
    //    await db.SaveChangesAsync(cancellationToken);
    //    return cap;
    //}

    //// Update Capability: updateCapability(id: Int!, name: String): Capability
    //public async Task<Capability?> UpdateCapabilityAsync(int id, string? name, CancellationToken cancellationToken = default)
    //{
    //    await using var db = _dbFactory.CreateDbContext();
    //    var cap = await db.Capabilities.FindAsync(new object[] { id }, cancellationToken);
    //    if (cap == null) return null;
    //    if (name is not null) cap.Name = name;
    //    await db.SaveChangesAsync(cancellationToken);
    //    return cap;
    //}

    //// Delete Capability: deleteCapability(id: Int!): Boolean
    //public async Task<bool> DeleteCapabilityAsync(int id, CancellationToken cancellationToken = default)
    //{
    //    await using var db = _dbFactory.CreateDbContext();
    //    var cap = await db.Capabilities.FindAsync(new object[] { id }, cancellationToken);
    //    if (cap == null) return false;
    //    db.Capabilities.Remove(cap);
    //    await db.SaveChangesAsync(cancellationToken);
    //    return true;
    //}
}
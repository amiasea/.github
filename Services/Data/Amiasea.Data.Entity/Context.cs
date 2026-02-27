using System;
using System.Collections.Generic;
using System.Net.NetworkInformation;
using System.Reflection.Emit;
using Amiasea.Aviator.Data.Entity.Configurations;
using Microsoft.EntityFrameworkCore;
//using Todo.Data.Entity.Configuration;

namespace Amiasea.Aviator.Data.Entity;

public class Context : DbContext
{
    public Context() : base() { }

    public Context(DbContextOptions<Context> options)
    : base(options)
    {
    }

    public DbSet<Airport> Airports { get; set; }

    public DbSet<Plane> Planes { get; set; }

    public DbSet<Capability> Capabilities { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.ApplyConfiguration(new AirportConfiguration());
        modelBuilder.ApplyConfiguration(new PlaneConfiguration());
        modelBuilder.ApplyConfiguration(new CapabilityConfiguration());

        modelBuilder.Entity<Airport>().HasData(
            new Airport { ID = 1, Name = "JFK International Airport" }
        );

        modelBuilder.Entity<Plane>().HasData(
            new Plane { ID = 1, AirportID = 1, Type = PlaneEnum.AUTHORITY }
        );

        modelBuilder.Entity<Capability>().HasData(
            new Capability { ID = 1, PlaneID = 1, Name = "Takeoff" },
            new Capability { ID = 2, PlaneID = 1, Name = "Landing" }
        );
    }
}
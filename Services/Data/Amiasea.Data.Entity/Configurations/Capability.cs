using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Amiasea.Aviator.Data.Entity.Configurations;

public class CapabilityConfiguration : IEntityTypeConfiguration<Capability>
{
    public void Configure(EntityTypeBuilder<Capability> builder)
    {
        builder.HasKey(c => c.ID);
        builder.HasIndex(x => new { x.Name, x.PlaneID }).IsUnique();
        builder.Property(c => c.Name).IsRequired().HasMaxLength(100);
        builder.HasOne(p => p.Plane);
    }
}
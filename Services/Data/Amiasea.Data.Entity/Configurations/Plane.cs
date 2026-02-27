using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Amiasea.Aviator.Data.Entity.Configurations;

internal class PlaneConfiguration : IEntityTypeConfiguration<Plane>
{
    public void Configure(EntityTypeBuilder<Plane> builder)
    {
        builder.HasKey(p => p.ID);
        builder.HasIndex(p => new { p.AirportID, p.Type }).IsUnique();
        //builder.Property(p => p.Repository).IsRequired().HasMaxLength(100);
        //builder.Property(p => p.Hangar).IsRequired().HasMaxLength(100);
        builder.HasOne(p => p.Airport)
               .WithMany(a => a.Planes)
               .HasForeignKey(p => p.AirportID);
        builder.HasMany(p => p.Capabilities);
    }
}
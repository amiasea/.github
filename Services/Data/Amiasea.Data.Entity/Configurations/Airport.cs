using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Amiasea.Aviator.Data.Entity.Configurations;

internal class AirportConfiguration : IEntityTypeConfiguration<Airport>
{
    public void Configure(EntityTypeBuilder<Airport> builder)
    {
        builder.HasKey(a => a.ID);
        builder.Property(a => a.Name).IsRequired().HasMaxLength(100);
        builder.HasMany(a => a.Planes)
               .WithOne(p => p.Airport)
               .HasForeignKey(p => p.AirportID);
    }
}

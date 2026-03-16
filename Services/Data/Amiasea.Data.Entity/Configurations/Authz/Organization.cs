using System.Collections.Generic;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using A = Amiasea.Data.Entity.Authz;

namespace Amiasea.Data.Entity.Configurations.Authz;

public class OrganizationConfiguration : IEntityTypeConfiguration<A.Organization>
{
    public void Configure(EntityTypeBuilder<A.Organization> builder)
    {
        builder.HasKey(e => e.ID);
        builder.HasIndex(e => e.Name).IsUnique();
        builder.HasIndex(e => e.Domain).IsUnique();
    }
}

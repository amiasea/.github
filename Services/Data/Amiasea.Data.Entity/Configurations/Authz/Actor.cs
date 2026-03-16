using System.Collections.Generic;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using A = Amiasea.Data.Entity.Authz;

namespace Amiasea.Data.Entity.Configurations.Authz;

public class ActorConfiguration : IEntityTypeConfiguration<A.Actor>
{
    public void Configure(EntityTypeBuilder<A.Actor> builder)
    {
        builder.HasKey(e => e.ID);
        builder.HasOne(e => e.Organization);
        builder.HasIndex(e => new { e.OrganizationID, e.Email }).IsUnique();
    }
}

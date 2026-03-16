using System.Collections.Generic;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using A = Amiasea.Data.Entity.Authz;

namespace Amiasea.Data.Entity.Configurations.Authz;

public class ActionConfiguration : IEntityTypeConfiguration<A.Action>
{
    public void Configure(EntityTypeBuilder<A.Action> builder)
    {
        builder.HasKey(e => e.ID);
        builder.HasOne(e => e.Resource);
        builder.HasIndex(e => new { e.ResourceID, e.Name }).IsUnique();
    }
}

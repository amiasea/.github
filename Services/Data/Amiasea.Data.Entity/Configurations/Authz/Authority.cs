using System.Collections.Generic;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using A = Amiasea.Data.Entity.Authz;

namespace Amiasea.Data.Entity.Configurations.Authz;

public class AuthorityConfiguration : IEntityTypeConfiguration<A.Authority>
{
    public void Configure(EntityTypeBuilder<A.Authority> builder)
    {
        builder.HasKey(e => e.ID);
        builder.HasIndex(e => e.Name).IsUnique();
    }
}

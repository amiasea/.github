using System.Collections.Generic;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using A = Amiasea.Data.Entity.Authz;

namespace Amiasea.Data.Entity.Configurations.Authz;

public class IdentityConfiguration : IEntityTypeConfiguration<A.Identity>
{
    public void Configure(EntityTypeBuilder<A.Identity> builder)
    {
        builder.HasKey(e => e.ID);
        builder.HasIndex(e => new { e.ActorID, e.AuthorityID, e.AuthorityIdentitfier }).IsUnique();
    }
}

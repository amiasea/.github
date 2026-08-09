- [Terraform Enterprise Stack](./terraform/enterprise_stack)
- [Terraform Enterprise Workspace](./terraform/enterprise_workspace)

Approach 1: Terraform Stack (enterprise_stack)
Architecture

Your stack is trying to do this:

deployment
    |
    v
component "whisper"
    |
    v
Azure Key Vault
    |
    v
component output
    |
    v
provider.github.enterprise
provider.github.org_scoped[*]
    |
    +--> organization_model
    |
    +--> organization_variables

The key feature is this:

provider "github" "org_scoped" {
  for_each = component.organization_model

  config {
    owner = each.value.name

    app_auth {
      pem_file = component.whisper.value
    }
  }
}

This is genuinely powerful.

Terraform traditionally cannot do this:

provider "github" {
  for_each = ...
}

Stacks introduce provider expansion at the component layer.

That solves your organizational scaling problem.

Stack Pros
1. Dynamic provider creation

This is the biggest win.

You can add:

organizations = [
  {
    name = "org_a"
  },
  {
    name = "org_b"
  }
]

and automatically get:

provider.github.org_scoped["org_a"]
provider.github.org_scoped["org_b"]

No duplicated module calls.

Your organization variable component naturally becomes:

component "organization_variables" {
  for_each = var.organizations

  providers = {
    github = provider.github.org_scoped[each.key]
  }
}

This is exactly the kind of thing Stacks were designed for.

2. Better enterprise composition

Your dependency model becomes very clean:

whisper
  |
  v
github enterprise provider
  |
  v
organization_model
  |
  v
organization_variables

The Stack becomes a deployment graph.

This matches the philosophy of Stacks.

3. Better multi-environment scaling

You could eventually have:

deployment "production"
deployment "sandbox"
deployment "dr"

all feeding the same component graph.

Stack Cons
1. The private key problem

This is the killer.

Your current design:

component.whisper.value

means:

Azure Key Vault
       |
       v
data source
       |
       v
component output
       |
       v
provider config

The moment you output:

output "value" {
  value = data.azurerm_key_vault_secret.secret.value
}

you are no longer in an ephemeral context.

The value has entered Terraform's data flow.

Terraform now has to track it.

Your original problem:

"I want the GitHub App private key to exist only in Key Vault."

Stacks currently cannot satisfy that through a component output.

2. Variable sets don't solve it

You correctly pushed back on this.

A Stack:

store "varset"

does not magically inject ephemeral values.

It provides inputs.

The value exists as Stack configuration.

That's not the same security model.

3. Stacks currently don't let top-level component wiring stay ephemeral

This is the fundamental limitation.

The ideal would be:

component.whisper.value

being marked ephemeral.

But today, component outputs don't have:

ephemeral = true

like module outputs.

Approach 2: Workspace (enterprise_workspace)
Architecture

Your workspace model is:

provider
 |
 +--> ephemeral azurerm_key_vault_secret
          |
          v
       github provider
          |
          v
       resources

Example:

ephemeral "azurerm_key_vault_secret" "github_key" {
  ...
}

provider "github" {
  app_auth {
    pem_file = ephemeral.azurerm_key_vault_secret.github_key.value
  }
}

This is exactly the intended Terraform ephemeral flow.

Workspace Pros
1. The private key never enters state

This is the biggest win.

The flow is:

Key Vault
    |
    v
ephemeral value
    |
    v
provider
    |
    v
API call

No:

state
plan
output
variable

The private key stays transient.

This matches your security requirement.

2. Provider configuration works naturally

Providers are configured directly:

provider "github" {
  app_auth {
    pem_file = ephemeral.secret.value
  }
}

No intermediate component.

3. Existing Terraform model is mature

Workspaces have:

provider inheritance
provider aliases
module providers
mature tooling
predictable behavior
Workspace Cons
1. Provider aliases are static

This is the painful part.

You need:

provider "github" {
  alias = "org_a"
}

provider "github" {
  alias = "org_b"
}

Then:

module "organization_variables_org_a" {
  providers = {
    github = github.org_a
  }
}

You cannot do:

for_each = organizations

provider = github[each.key]

Terraform does not allow provider collections.

2. Module instantiation becomes repetitive

Your code becomes:

module "organization_variables_org_a"
module "organization_variables_org_b"
module "organization_variables_org_c"

instead of:

component "organization_variables" {
  for_each = organizations
}
3. Adding organizations requires Terraform code changes

With Stacks:

add organization object
apply

With workspace aliases:

add provider alias
add module block
add wiring
apply

Less declarative.

What you actually want

The ideal design would look like this:

ephemeral "azurerm_key_vault_secret" "github_key" {
  ...
}


provider "github" "org_scoped" {
  for_each = var.organizations

  config {
    owner = each.value.name

    app_auth {
      pem_file = ephemeral.azurerm_key_vault_secret.github_key.value
    }
  }
}


component/module "organization_variables" {
  for_each = var.organizations

  providers = {
    github = provider.github.org_scoped[each.key]
  }
}

Security:

Key Vault
   |
   v
ephemeral
   |
   v
dynamic providers
   |
   v
GitHub

Scalability:

organizations = [
 org_a,
 org_b,
 org_c
]

creates:

github.org_scoped["org_a"]
github.org_scoped["org_b"]
github.org_scoped["org_c"]

Automatically.

That is the best-of-both-worlds design.

## Your current decision point

Given your stated priority:

> "I don't want the private key stored anywhere except Key Vault."

That requirement is the deciding factor.

Today:

| Capability | Stack | Workspace |
|---|---|---|
| Dynamic providers | ✅ | ❌ |
| `for_each` providers | ✅ | ❌ |
| Component model | ✅ | ❌ |
| Ephemeral Key Vault secret into provider | ❌ | ✅ |
| Private key absent from state | ❌ | ✅ |
| Mature provider behavior | ⚠️ | ✅ |
| Simple security story | ⚠️ | ✅ |

So the uncomfortable conclusion is:

The Workspace implementation is the one that satisfies your primary security requirement.

The Stack implementation is architecturally cleaner for a GitHub Enterprise factory, but it currently forces you to choose between:

leaking the secret into Terraform's managed data flow, or
abandoning the ephemeral guarantee.

Your frustration with Stacks is justified: the missing feature is not "ephemeral outputs are missing"; the missing feature is ephemeral values crossing the component boundary into provider configuration.

That is exactly the seam where you need the two models to meet.
# 1. Define the "Sovereign" Rule
# This rule ONLY allows auto-approval if the component is NOT a core one.
deployment_auto_approve "app_only" {
  condition = context.plan.component != "identity" && context.plan.component != "hub_network"
}

# 2. Apply it to your Deployment
deployment "production" {
  inputs = {
    regions = ["westeurope"]
  }

  # If the component is "identity", this rule returns 'false' 
  # and the Stack stops for YOUR manual approval.
  auto_approve = deployment_auto_approve.app_only
}

identity_token "azure" {
  # This must match the 'Audience' in your Azure Federated Credential
  audience = ["api://AzureADTokenExchange"]
}

deployment_auto_approve "safe_factory_updates" {
  check {
    condition = context.plan.changes.remove == 0
    reason    = "Plan would delete ${context.plan.changes.remove} repositories. Manual review required."
  }
}

deployment_group "factory_automation" {
  auto_approve_checks = [
    deployment_auto_approve.safe_factory_updates
  ]
}

deployment "projects" {
  inputs = {
    project_list = [
      "test"
    ]
    azure_oidc_token = identity_token.azure.jwt
  }
}
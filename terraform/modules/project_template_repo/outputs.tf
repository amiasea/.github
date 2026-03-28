output "repository_name" {
  value       = github_repository.project_template.name
  description = "The name of the template repo, available only after creation."
  
  # This ensures the output is 'locked' until the repo is ready
  depends_on = [github_repository.project_template] 
}
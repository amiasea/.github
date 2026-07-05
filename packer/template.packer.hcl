packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "://github.com"
    }
  }
}

variable "github_actor"    { type = string }
variable "github_token"    { type = string }
variable "repo_name"       { type = string }
variable "semver_tag"      { type = string } 
variable "dockerfile_path" { type = string }

hcp_packer_registry {
  bucket_name = "amiasea-api"
  description = "Amiasea Core API Releases"
}

source "docker" "api" {
  image       = "null"
  discard     = true
  commit      = false
  build_dir   = ".." 
  dockerfile  = var.dockerfile_path
}

build {
  sources = ["source.docker.api"]
  post-processors {
    post-processor "docker-tag" {
      repository = "ghcr.io/amiasea/${var.repo_name}"
      tags       = [var.semver_tag, "latest"]
    }
    post-processor "docker-push" {
      login          = true
      login_username = var.github_actor
      login_password = var.github_token
      login_server   = "ghcr.io"
    }
  }
}

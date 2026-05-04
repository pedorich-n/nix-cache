terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.8"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }

    onepassword = {
      source  = "1Password/onepassword"
      version = "~> 3.3"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

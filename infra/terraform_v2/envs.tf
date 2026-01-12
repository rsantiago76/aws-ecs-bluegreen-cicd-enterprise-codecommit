locals {
  env_config = {
    dev     = { desired_count = 1 }
    staging = { desired_count = 1 }
    prod    = { desired_count = 2 }
  }

  envs = { for e in var.environments : e => merge({ name = e }, lookup(local.env_config, e, {})) }
}

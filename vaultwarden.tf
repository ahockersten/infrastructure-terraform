# Call the vaultwarden module
module "vaultwarden" {
  source = "./modules/vaultwarden"

  # Pass required variables
  billing_account    = "01601B-D26B44-151179" # Keep the hardcoded value for now, or create a root variable
  user_email         = var.user_email
  github_owner       = var.github_owner
  cloudflare_zone_id = cloudflare_zone.hockersten_se.id

  # Pass provider configurations
  providers = {
    google      = google
    google-beta = google-beta
    github      = github
    cloudflare  = cloudflare
  }
}

# Moved blocks to inform Terraform about resource relocation
moved {
  from = google_project.vaultwarden
  to   = module.vaultwarden.google_project.vaultwarden
}

moved {
  from = google_project_service.services["artifactregistry.googleapis.com"]
  to   = module.vaultwarden.google_project_service.services["artifactregistry.googleapis.com"]
}
moved {
  from = google_project_service.services["cloudscheduler.googleapis.com"]
  to   = module.vaultwarden.google_project_service.services["cloudscheduler.googleapis.com"]
}
moved {
  from = google_project_service.services["iamcredentials.googleapis.com"]
  to   = module.vaultwarden.google_project_service.services["iamcredentials.googleapis.com"]
}
moved {
  from = google_project_service.services["run.googleapis.com"]
  to   = module.vaultwarden.google_project_service.services["run.googleapis.com"]
}
moved {
  from = google_project_service.services["secretmanager.googleapis.com"]
  to   = module.vaultwarden.google_project_service.services["secretmanager.googleapis.com"]
}
# Note: iam.googleapis.com service was added in the module, no moved block needed.

moved {
  from = google_service_account.backup_job_service_account
  to   = module.vaultwarden.google_service_account.backup_job_service_account
}

moved {
  from = google_project_iam_member.cloudrun_job_executor
  to   = module.vaultwarden.google_project_iam_member.cloudrun_job_executor
}

moved {
  from = google_service_account.vaultwarden_service_account
  to   = module.vaultwarden.google_service_account.vaultwarden_service_account
}

moved {
  from = google_secret_manager_secret.admin_token
  to   = module.vaultwarden.google_secret_manager_secret.admin_token
}

moved {
  from = google_secret_manager_secret_iam_member.secret_accessor_admin_token
  to   = module.vaultwarden.google_secret_manager_secret_iam_member.secret_accessor_admin_token
}

moved {
  from = google_secret_manager_secret.smtp_password
  to   = module.vaultwarden.google_secret_manager_secret.smtp_password
}

moved {
  from = google_secret_manager_secret_iam_member.secret_accessor_smtp_password
  to   = module.vaultwarden.google_secret_manager_secret_iam_member.secret_accessor_smtp_password
}

moved {
  from = google_cloud_run_v2_service.vaultwarden
  to   = module.vaultwarden.google_cloud_run_v2_service.vaultwarden
}

moved {
  from = google_cloud_run_v2_job.vaultwarden_backup
  to   = module.vaultwarden.google_cloud_run_v2_job.vaultwarden_backup
}

moved {
  from = google_cloud_scheduler_job.vaultwarden_backup_job
  to   = module.vaultwarden.google_cloud_scheduler_job.vaultwarden_backup_job
}

moved {
  from = google_storage_bucket.vaultwarden
  to   = module.vaultwarden.google_storage_bucket.vaultwarden
}

moved {
  from = google_storage_bucket_iam_member.vaultwarden_access_vaultwarden
  to   = module.vaultwarden.google_storage_bucket_iam_member.vaultwarden_access_vaultwarden
}

moved {
  from = google_storage_bucket_iam_member.backup_access_vaultwarden
  to   = module.vaultwarden.google_storage_bucket_iam_member.backup_access_vaultwarden
}

moved {
  from = google_storage_bucket_iam_member.backup_access_backup
  to   = module.vaultwarden.google_storage_bucket_iam_member.backup_access_backup
}

moved {
  from = google_storage_bucket.vaultwarden_backup
  to   = module.vaultwarden.google_storage_bucket.vaultwarden_backup
}

moved {
  from = google_cloud_run_v2_service_iam_member.noauth
  to   = module.vaultwarden.google_cloud_run_v2_service_iam_member.noauth
}

moved {
  from = google_cloud_run_domain_mapping.vaultwarden
  to   = module.vaultwarden.google_cloud_run_domain_mapping.vaultwarden
}

# Moved blocks for the Cloudflare DNS records created by the for_each loop
# Terraform expands the for_each, so we need a moved block for each instance.
# The keys are derived from the loop: 0, 1, 2, 3 based on the indices of resource_records.
moved {
  from = cloudflare_dns_record.vaultwarden_hockersten_se["0"]
  to   = module.vaultwarden.cloudflare_dns_record.vaultwarden_hockersten_se["0"]
}
moved {
  from = cloudflare_dns_record.vaultwarden_hockersten_se["1"]
  to   = module.vaultwarden.cloudflare_dns_record.vaultwarden_hockersten_se["1"]
}
moved {
  from = cloudflare_dns_record.vaultwarden_hockersten_se["2"]
  to   = module.vaultwarden.cloudflare_dns_record.vaultwarden_hockersten_se["2"]
}
moved {
  from = cloudflare_dns_record.vaultwarden_hockersten_se["3"]
  to   = module.vaultwarden.cloudflare_dns_record.vaultwarden_hockersten_se["3"]
}


moved {
  from = google_artifact_registry_repository.docker_repo
  to   = module.vaultwarden.google_artifact_registry_repository.docker_repo
}

moved {
  from = github_repository.vaultwarden_backup
  to   = module.vaultwarden.github_repository.vaultwarden_backup
}

moved {
  from = github_actions_variable.vaultwarden_backup_env_project_id
  to   = module.vaultwarden.github_actions_variable.vaultwarden_backup_env_project_id
}

moved {
  from = github_actions_variable.vaultwarden_backup_env_gar_location
  to   = module.vaultwarden.github_actions_variable.vaultwarden_backup_env_gar_location
}

moved {
  from = github_actions_variable.vaultwarden_backup_env_gar_repository
  to   = module.vaultwarden.github_actions_variable.vaultwarden_backup_env_gar_repository
}

moved {
  from = github_actions_variable.vaultwarden_backup_env_image_name
  to   = module.vaultwarden.github_actions_variable.vaultwarden_backup_env_image_name
}

moved {
  from = github_actions_variable.vaultwarden_backup_env_pool_id
  to   = module.vaultwarden.github_actions_variable.vaultwarden_backup_env_pool_id
}

moved {
  from = github_actions_variable.vaultwarden_backup_env_provider_id
  to   = module.vaultwarden.github_actions_variable.vaultwarden_backup_env_provider_id
}

moved {
  from = github_actions_variable.vaultwarden_backup_env_cloud_run_service_name
  to   = module.vaultwarden.github_actions_variable.vaultwarden_backup_env_cloud_run_service_name
}

moved {
  from = github_actions_variable.vaultwarden_backup_env_cloud_run_region
  to   = module.vaultwarden.github_actions_variable.vaultwarden_backup_env_cloud_run_region
}

moved {
  from = google_project_iam_member.user_sa_token_creator
  to   = module.vaultwarden.google_project_iam_member.user_sa_token_creator
}

moved {
  from = google_project_iam_member.user_wi_pool_admin
  to   = module.vaultwarden.google_project_iam_member.user_wi_pool_admin
}

moved {
  from = google_iam_workload_identity_pool.github_pool
  to   = module.vaultwarden.google_iam_workload_identity_pool.github_pool
}

moved {
  from = google_iam_workload_identity_pool_provider.github_provider
  to   = module.vaultwarden.google_iam_workload_identity_pool_provider.github_provider
}

moved {
  from = google_project_iam_member.github_actions_artifact_writer
  to   = module.vaultwarden.google_project_iam_member.github_actions_artifact_writer
}

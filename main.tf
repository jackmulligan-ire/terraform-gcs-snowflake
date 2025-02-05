terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.16.0"
    }

    snowflake = {
      source = "Snowflake-Labs/snowflake"
      version = "1.0.2"
      
    }
  }
}

# PROVIDERS
provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}

provider "snowflake" {
  organization_name = "jwgmlqm"
  account_name = "iyb77489"
  user = "tf-snow"
  role = "ACCOUNTADMIN"
  authenticator = "SNOWFLAKE_JWT"
  # Uses SNOWFLAKE_PRIVATE_KEY environment variable to authenticate 

  preview_features_enabled = [
    "snowflake_storage_integration_resource", 
    "snowflake_stage_resource",
    "snowflake_file_format_resource"
    ]  
}

# GCP INFRA
resource "google_storage_bucket" "terraform_demo_bucket" {
  name          = "${var.project}-terra-sf-bucket"
  location      = var.location
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_project_iam_custom_role" "snowflake_gcs_role" {
  role_id     = "SnowflakeGCSRole" # Unique identifier for the role
  title       = "Snowflake GCS Role"
  description = "Custom role for Snowflake to access Google Cloud Storage"

  permissions = [
    "storage.buckets.get",
    "storage.objects.get",
    "storage.objects.list",
  ]

  project = var.project
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.terraform_demo_bucket.name
  role = google_project_iam_custom_role.snowflake_gcs_role.id
  member = "serviceAccount:${snowflake_storage_integration.gcs_storage_integration.storage_gcp_service_account}"
}

# SNOWFLAKE INFRA
resource "snowflake_database" "terraform_demo_db" {
  name = "${var.sf_project}_DB"
  comment = "Terraform demo database"
}

resource "snowflake_schema" "terraform_demo_schema" {
  name = "${var.sf_project}_SCHEMA"
  database = snowflake_database.terraform_demo_db.name
}

resource "snowflake_user" "terraform_demo_user" {
  name = "${var.sf_project}_USER"
  rsa_public_key   = var.sf_project_private_key
  must_change_password = "false"
}

resource "snowflake_grant_account_role" "g" {
  role_name = "ACCOUNTADMIN"
  user_name = snowflake_user.terraform_demo_user.name
}

resource "snowflake_file_format" "terraform_file_format" {
  name = "${var.sf_project}_FILE_FORMAT"
  database = snowflake_database.terraform_demo_db.name
  schema = snowflake_schema.terraform_demo_schema.name
  format_type = "PARQUET"
}

resource "snowflake_storage_integration" "gcs_storage_integration" {
  name = "${var.sf_project}_GCS_STORAGE_INTEGRATION"
  type = "EXTERNAL_STAGE"
  storage_provider = "GCS"
  enabled = true

  storage_allowed_locations = ["gcs://${google_storage_bucket.terraform_demo_bucket.name}"]
}

resource "snowflake_stage" "gcs_external_stage" {
  name = "${var.sf_project}_EXTERNAL_STAGE"
  database = snowflake_database.terraform_demo_db.name
  schema = snowflake_schema.terraform_demo_schema.name
  url = "gcs://${google_storage_bucket.terraform_demo_bucket.name}"
  storage_integration = snowflake_storage_integration.gcs_storage_integration.name
  file_format = "FORMAT_NAME = ${snowflake_file_format.terraform_file_format.fully_qualified_name}"
}
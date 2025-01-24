variable "credentials" {
  description = "Google Cloud service account credentials"
  default     = "~/google_credentials.json"
}

variable "project" {
  description = "Google Cloud project ID"
  default     = "terraform-demo-448321"
}

variable "region" {
  description = "Google Cloud project region"
  default     = "eur-central1"
}

variable "location" {
  description = "Google Cloud project location"
  default     = "EU"
}
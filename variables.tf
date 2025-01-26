variable "credentials" {
  description = "Google Cloud service account credentials"
  default     = "~/google_credentials.json"
}

variable "project" {
  description = "Google Cloud project ID"
  default     = "terraform-demo-448321"
}

variable "sf_project" {
  description = "Snowflake Project ID"
  default     = "terraform_demo_448321"
}

variable "sf_project_private_key" {
  description = "Snowflake Private Key"
  default     = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2QS/GWIW/5D/4gVp5X+U6+EPLwgrg38sSn6HK84FLMpcLte/FbCXVJ8U+hiSqXv+0mzZ9o03dWR2a4EBzvhi2AyC7NaoGIFA7R9lTjYyF3v2i0yRy6uLvFbKe5bShbHf6X5Abrs9ZEu9B+SUxRVvec9y7UaZooBYP2ydVckoDr9+83t8ZN467ibp2NZaEbHzp7G/wOCdeMb2WC3VQtV3boPhEoFfw6qH6LinSttVaeuk9C+U/eyyEEeBPAYSQdELWAZ5SdfpIgCtHVfRQ8qLRtYWyoN4NPM1G8dr8jiIoTi4xlAUX6C1Z+1AY9QqP3ZKktQNDKrofW8A4fd+PcTrqwIDAQAB"
}

variable "region" {
  description = "Google Cloud project region"
  default     = "eur-central1"
}

variable "location" {
  description = "Google Cloud project location"
  default     = "EU"
}
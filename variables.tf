variable "access_token" {
  description = "access_token"
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "project_id"
  type        = string
  default     = "airline1-sabre-wolverine"
}

variable "key_ring" {
  description = "key_ring"
  type        = string
  default     = "projects/airline1-sabre-wolverine/locations/us/keyRings/savita-keyring-us"
}

variable "org" {
  description = "org"
  type        = string
  default     = "wf"
}

variable "country" {
  description = "country"
  type        = string
  default     = "us"
}

variable "env" {
  description = "env"
  type        = string
  default     = "prod"
}

variable "appid" {
  description = "appid"
  type        = string
  default     = "demo"
}

variable "uid" {
  description = "uid"
  type        = string
  default     = "u1234"
}


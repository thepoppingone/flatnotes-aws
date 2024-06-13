
variable "vpc_id" {
  description = "VPC ID"
  default     = "vpc-05d23fd53c23eaba6" # personal acc test ID, please change this.
}

variable "public_subnets_ids" {
  description = "List of Public Subnets IDs"
  default     = ["subnet-0e836ff84212395c8", "subnet-0007831a1dea41b89", "subnet-02e7925c27ca569b0"]
}

variable "flatnotes_username" {
  sensitive = true
  default   = "test_user"
}

variable "flatnotes_password" {
  sensitive = true
  default   = "test_password"
}

variable "flatnotes_secret_key" {
  sensitive = true
  default   = "test_secret_key"
}

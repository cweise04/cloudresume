
variable "cw_resume_dynamodb" {
  description = "Name of the DynamoDb Table"
  type        = string
  default     = "cwresume-dbtable"

}

variable "visit_counter_name" {
  description = "The name of the partition key (VisitCounter)"
  type        = string
  default     = "VisitCounter"
}

variable "visit_counter_type" {
  description = "The type of the partition key"
  type        = string
  default     = "S"
}

variable "billing_mode" {
  description = "The billing mode of CW Cloud Resume as IaaC"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "cw_resume_s3" {
  description = "Name of S3 bucket"
  type        = string
  default     = "cw-cloud-resume-website"
}

variable "website_index_document" {
  description = "Website files"
  type        = string
  default     = "index.html"
}


variable "domain_name" {
  description = "Primary domain name"
  type        = string
  default     = "cwcloudresume.me"
}

variable "secondary_domain_name" {
  description = "Secondary domain name"
  type        = string
  default     = "www.cwcloudresume.me"
}


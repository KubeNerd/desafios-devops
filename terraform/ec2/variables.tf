variable "aws_region" {
  type        = string
  description = "AWS Region for create resource"
  default     = "us-east-1"
}

# variable "aws_ip_range_permission" {
#     type = string
#     description = "AWS IP range list"
#     default = ""
# }

variable "aws_common_tags" {
  type = map(any)
  default = {
    Name       = "Devops"
    Owner      = "Lelecoxin"
    Department = "Devops"
  }
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}


variable "environment_name" {
    type    = string
    default = "cloudforce"
}

variable "ami_id" {
    type = string
    default = "ami-05134c8ef96964280"

}

variable "instance_type" {
    type = string
    default = "t2.micro"

}

variable "cloudforce_trail" {
    description = "Bucket name to store cloud trails"
    type = string
    default = "cloudforce"

}

variable "managed_origin_request_policy_id" {
  type = string
  default = "33f36d7e-f396-46d9-90e0-52428a34d9dc"
}
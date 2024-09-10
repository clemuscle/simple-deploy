variable "region" {
    default = "eu-west-3"
}

variable "aws_access_key" {
    description = "My AWS access key"
    type = string
    sensitive = true
}

variable "aws_secret_key" {
    description = "My AWS secret key"
    type = string
    sensitive = true
}
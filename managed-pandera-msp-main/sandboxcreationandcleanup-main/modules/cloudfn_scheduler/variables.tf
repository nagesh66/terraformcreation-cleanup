variable "function_name" {
  type    = string
  default = "msp-project-cleanup-function"
}

variable "project_id" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "runtime" {
  type    = string
  default = "python39"
}

variable "entry_point" {
  type    = string
  default = "stop_billing"
}

variable "source_dir" {
 type  = string
  
}

variable "sa_email" {
    type = string
    default = ""
}
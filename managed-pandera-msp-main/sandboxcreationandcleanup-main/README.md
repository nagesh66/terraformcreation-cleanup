# SandboxCreationAndCleanUp

The purpose of this repository is to serve as a basis to have consistent definition of
gcp infrastructure for sandbox project creation via terraform and cleanup using Cloud scheduler and Cloudfunction.
To Create a new sandbox project, clone this repository and then create a new branch with the intended name for sandbox environment.

# About
This terraform configuration creates the folder structure and projects for any given sandbox environment as per the request

# Terraform Design
The Terraform scripts run against existing enviroments hosted on GCP
 
# Getting Started
The following dependancies are needed to run Terraform

[Terraform](https://www.terraform.io/downloads.html)

[python](https://www.python.org/downloads/only) necessary if you would want to run the python code locally.

## Executing Against Sandbox Environment
Terraform script structure
```shell
.
├── README.md
├── envs
│   └── prod
│       ├── config
│       │   ├── backend.tf
│       │   └── terraform.tfvars
│       └── output
└── src   
    ├── main.tf
    ├── provider.tf
    ├── variables.tf
    └── version.tf
```
#### envs/{environment}/config/backend.tf

```terraform
terraform {
  backend "gcs" {
    bucket = "pandera-terraform-managed-state"
    prefix = "{sandboxname}/{environment}/"
  }
}
```
#### envs/{environment}/config/terraform.tfvars
Apply variables needed for the modules defined in your main.tf in this file.  These variables will be environment specific.

Examples:

```terraform
      project_id          
      project_name        
      folder_id           
      billing_id     
```      

#### src/main.tf
Resources being created for the sandbox project should be designed by referencing modules from this repository.  To Reference a module use the following format:

To Reference a module use the following format:

```terraform
      module "project" {
    source = "../modules/project"
    project_id              =   var.project_id
    folder_id               =   var.folder_id
    billing_id              =   var.billing_id
    label                   =   var.label
}
```

To Reference modules in a Gitlab repo, use this format:

```terraform
module "module_name" {
    source = "git::ssh://git@code.panderasystems.com/cloud-engineering/infrastructure/terraform-templates/terraform-ms-modules.git//modules/path/to/module"
    
    variable_name              =   var.variable_name
}

```
#### src/variables.tf
Define all the variables being used in the Sandbox repository here.

#### src/version.tf
```terraform
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 3.0.0"
    }
  }
  required_version = "~> 1.0.0"
}
```

#### Cloud function (main.py)

This function lives in the pandera-devOps-terraform project in GCP and would be triggered by a cloud scheduler that lives in the same project.
The cloud function searchs through GCP Projects and finds projects with the label `labels.env:sandbox'. If a project is older than 30 days, a notification is sent to the Cloud practice group that the billingID will be disabled soon. If the project is older than 60 days, the project is marked for deletion. Deletion starts at an unspecified time, at which point the project is no longer accessible.

Below are GCP API methods used.
Projects:
- search - Search for projects that the caller has both resourcemanager.projects.get permission on, and also satisfy the specified query.

This method returns projects in an unspecified order.

- delete - Marks the project identified by the specified name (for example, projects/415104041262) for deletion.

```python
    def SandBoxCreationAndCleanUp():
        {code containing logic to check the duration of the project and remove billingID if needed or deletion entirely}
```

#### Cloud Scheduler
The scheduler runs on the at the end of every month and Invokes a cloud function. The scheduler contains an empty body, as no data is needed.

Target URL : https://us-east1-pandera-cloud-devops-terraform.cloudfunctions.net/SandboxCreationAndCleanUp




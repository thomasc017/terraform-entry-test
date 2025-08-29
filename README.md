# terraform-entry-test

First you will need to create the environment with docker-compose up -d. Assuming you have docker installed, this should create three separate databases postgres1-3. Each of these databases have the same configuration.

Before running terraform however, you will need to create separate workspaces:
    -  e.g. terraform workspace new postgres1
    - terraform workspace select postgres1

Inside the corresponding workspace:
    - terraform init
    - terraform plan
    - terraform apply (you can either interactively enter the username and password, or do so via the command-line flags
    )
        - "var="db_host=localhost" etc."

1

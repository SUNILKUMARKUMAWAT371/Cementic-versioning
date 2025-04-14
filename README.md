# ONDC OFFICIAL

## Overview

This repository contains the configuration and deployment scripts for various ONDC (Open Network for Digital Commerce) components across different environments. It includes mock servers, protocol server engines, sandbox components, and utilities for domains like B2B, FIS (Financial Information Services), IGM (Issue and Grievance Management), RSF (Registry and Settlement Framework), and TRV (Travel).

## Environments

The repository manages configurations for the following environments:

*   **Staging:** Used for testing and validation before production. All components (B2B, FIS, IGM, RSF, TRV) are deployed to the Staging environment.
*   **Preprod (Pre-production):** A final testing environment closely mirroring production. Currently, only IGM and RSF components are deployed to the Preprod environment.

*Note: While the folder structure includes `preprod` directories for FIS, B2B, and TRV components, the current deployment strategy targets only the Staging environment for these specific components.*

## Folder Structure

The repository is organized by component, then service/utility within that component, and finally by environment. Each environment-specific directory typically contains a `Jenkinsfile` for CI/CD pipelines and an `env` file or configuration related to that environment.

```
ONDC
├── B2B
│   └── ondc_mock_server
│       ├── preprod
│       └── staging
│           ├── Jenkinsfile
│           └── env
├── FIS
│   ├── mock_server_utility
│   │   ├── preprod
│   │   └── staging
│   │       ├── Jenkinsfile
│   │       └── env
│   ├── protocol_server_engine
│   │   ├── preprod
│   │   └── staging
│   │       ├── Jenkinsfile
│   │       └── env
│   ├── sandbox_backend
│   │   ├── preprod
│   │   └── staging
│   │       ├── Jenkinsfile
│   │       └── env
│   ├── sandbox_ui
│   │   ├── preprod
│   │   └── staging
│   │       ├── Jenkinsfile
│   │       └── env
│   └── seller_mock_engine
│       ├── preprod
│       └── staging
│           ├── Jenkinsfile
│           └── env
├── IGM
│   ├── mock_ui
│   │   ├── preprod
│   │   │   ├── Jenkinsfile
│   │   │   └── env
│   │   └── staging
│   │       ├── Jenkinsfile
│   │       └── env
│   ├── protocol_server_engine
│   │   ├── preprod
│   │   │   ├── Jenkinsfile
│   │   │   └── env
│   │   └── staging
│   │       ├── Jenkinsfile
│   │       └── env
│   └── seller_mock_engine
│       ├── preprod
│       │   ├── Jenkinsfile
│       │   └── env
│       └── staging
│           ├── Jenkinsfile
│           └── env
├── RSF
│   ├── mock_ui
│   │   ├── preprod
│   │   │   ├── Jenkinsfile
│   │   │   └── env
│   │   └── staging
│   │       ├── Jenkinsfile
│   │       └── env
│   ├── protocol_server_engine
│   │   ├── preprod
│   │   │   ├── Jenkinsfile
│   │   │   └── env
│   │   └── staging
│   │       ├── Jenkinsfile
│   │       └── env
│   └── seller_mock_engine
│       ├── preprod
│       │   ├── Jenkinsfile
│       │   └── env
│       └── staging
│           ├── Jenkinsfile
│           └── env
├── TRV
    ├── mock_server_utility
    │   ├── preprod
    │   └── staging
    │       ├── Jenkinsfile
    │       └── env
    ├── protocol_server_engine
    │   ├── preprod
    │   └── staging
    │       ├── Jenkinsfile
    │       └── env
    ├── sandbox_backend
    │   ├── preprod
    │   └── staging
    │       ├── Jenkinsfile
    │       └── env
    ├── sandbox_ui
    │   ├── preprod
    │   └── staging
    │       ├── Jenkinsfile
    │       └── env
    └── seller_mock_engine
        ├── preprod
        └── staging
            ├── Jenkinsfile
            └── env
```

## Components

*   **B2B:** Components related to Business-to-Business interactions.
*   **FIS:** Components related to Financial Information Services.
*   **IGM:** Components for Issue and Grievance Management.
*   **RSF:** Components for Registry and Settlement Framework.
*   **TRV:** Components related to the Travel domain.

Each component directory contains sub-directories for specific services like `mock_server_utility`, `protocol_server_engine`, `sandbox_backend`, `sandbox_ui`, `seller_mock_engine`, etc.

## Deployment

Deployments to the Staging and Preprod environments are automated using Jenkins pipelines.

*   Each service within a component and environment (e.g., `IGM/mock_ui/staging/`) contains a `Jenkinsfile` defining its specific deployment pipeline.
*   These pipelines typically handle tasks such as:
    *   Checking out the correct source code branch.
    *   Loading environment-specific configurations and secrets.
    *   Building Docker images (if applicable).
    *   Deploying the application (e.g., using Docker Compose on target EC2 instances).
    *   Performing necessary cleanup actions.

For detailed information on a specific deployment pipeline, refer to the `Jenkinsfile` within the corresponding service/environment directory.

## Prerequisites

*   Git: For cloning and managing the repository.
*   Access to the relevant Jenkins instance (for triggering deployments).
*   Appropriate credentials configured in Jenkins (e.g., SSH keys, secret files) for accessing target deployment servers and environment variables.
#
#

# Jenkinsfile Structure

## Overview

This repository contains a `Jenkinsfile` that defines a declarative pipeline for automating the deployment of the `ONDC-Official/mock-server-utility` application (specifically the `TRV` branch) to a designated staging EC2 instance.

The pipeline performs the following key actions:
1.  Loads sensitive environment variables from Jenkins credentials.
2.  Connects to the target EC2 instance via SSH.
3.  Clones the specified Git repository or updates the existing clone.
4.  Writes the loaded environment variables to a `.env` file on the EC2 instance.
5.  Uses Docker Compose to stop, build, and deploy the application containers.
6.  Includes a (currently partial) cleanup stage for Docker resources.

## Prerequisites

Before running this pipeline, ensure the following are configured:

1.  **Jenkins Instance:** A running Jenkins instance with necessary plugins installed (Pipeline, Credentials Binding, SSH Agent).
2.  **EC2 Instance:**
    *   An accessible EC2 instance with the IP address `3.7.217.131`.
    *   An SSH user `ahsan_witslab` configured on the EC2 instance.
    *   This user must have `sudo` privileges to run Docker commands and write the `.env` file.
    *   Docker and Docker Compose must be installed and running on the EC2 instance.
3.  **Jenkins Credentials:**
    *   **`TRV_Staging_SSH_Keys`**: An "SSH Username with private key" credential type in Jenkins. This should contain the private SSH key corresponding to the public key authorized for the `ahsan_witslab` user on the EC2 instance.
    *   **`trv_mock_server_utility_staging`**: A "Secret file" credential type in Jenkins. This file should contain the environment variables required by the application, formatted one per line (e.g., `VAR1=value1\nVAR2=value2`).

## Pipeline Configuration

The pipeline uses the following environment variables defined in the `environment` block:

*   `EC2_USER`: `ahsan_witslab` - The username for SSH connection to the EC2 instance.
*   `EC2_HOST`: `3.7.217.131` - The IP address of the target staging EC2 instance.
*   `REPO_URL`: `https://github.com/ONDC-Official/mock-server-utility` - The URL of the Git repository to clone.
*   `BRANCH_NAME`: `TRV` - The specific branch to check out and deploy.
*   `CLONE_PATH`: `trv-mock-server-utility-staging` - The directory name on the EC2 instance where the repository will be cloned.

## Pipeline Stages

The pipeline is divided into the following stages:

1.  **Load Secrets:**
    *   Retrieves the content of the Jenkins secret file credential `trv_mock_server_utility_staging`.
    *   Stores the content (expected to be environment variable definitions) into the `SECRET_ENV_VARS` Jenkins environment variable.

2.  **Connect to EC2 & Clone Repo:**
    *   Uses the `TRV_Staging_SSH_Keys` credential to establish an SSH connection to the EC2 instance (`ahsan_witslab@3.7.217.131`).
    *   Checks if the target directory (`$CLONE_PATH`) exists on the EC2 instance.
    *   If the directory exists, it navigates into it, resets any local changes (`git reset --hard`), checks out the specified branch (`$BRANCH_NAME`), and pulls the latest changes (`git pull origin $BRANCH_NAME`).
    *   If the directory does not exist, it clones the repository (`$REPO_URL`) using the specified branch (`$BRANCH_NAME`) into the target directory (`$CLONE_PATH`).

3.  **Load Environment Variables on EC2:**
    *   Connects to the EC2 instance via SSH again.
    *   Navigates into the cloned repository directory (`$CLONE_PATH`).
    *   Takes the environment variables stored in the Jenkins `SECRET_ENV_VARS` variable and writes them into a `.env` file within the repository directory on the EC2 instance using `sudo tee`. This `.env` file is typically used by Docker Compose to inject environment variables into containers.

4.  **Build & Deploy:**
    *   Connects to the EC2 instance via SSH.
    *   Navigates into the repository directory (`$CLONE_PATH`).
    *   Stops any currently running containers defined in the `docker-compose.yml` file using `sudo docker-compose down`.
    *   Builds the Docker images (if changes are detected or images don't exist) and starts the application services in detached mode (`-d`) using `sudo docker-compose up -d --build`.

5.  **Clean Docker & Workspace:**
    *   Connects to the EC2 instance via SSH.
    *   Prints messages indicating cleanup.
    *   **Note:** The command `sudo docker system prune -af` (which removes unused Docker resources like stopped containers, unused networks, dangling images, and build cache) is currently **commented out** in the `Jenkinsfile`.

## Post Actions

The pipeline includes `post` conditions:

*   **`success`**: If all stages complete successfully, it prints "🎉 Deployment successful!".
*   **`failure`**: If any stage fails, it prints "❌ Deployment failed!".

## How to Use

1.  Ensure all prerequisites are met (EC2 setup, Docker/Docker Compose installation, Jenkins credentials).
2.  Create a new Jenkins Pipeline job.
3.  Configure the job to use "Pipeline script from SCM".
    *   Set the SCM to Git.
    *   Provide the repository URL where this `Jenkinsfile` resides.
    *   Specify the correct branch.
    *   Ensure the "Script Path" field points to `Jenkinsfile` (this is usually the default).
4.  Alternatively, you can choose "Pipeline script" and paste the content of this `Jenkinsfile` directly into the text area.
5.  Save the job configuration.
6.  Run the Jenkins job ("Build Now"). The pipeline will execute the defined stages.

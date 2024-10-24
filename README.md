CICD PROJECT: Production Level Blog APP Deployment using EKS, Nexus, SonarQube, Trivy with Monitoring Tools

Tools Used:
Jenkins: For managing the CI/CD pipeline.
SonarQube: For static code analysis.
Nexus: For managing dependencies and artifacts.
Trivy: For scanning vulnerabilities in files and Docker images.
Docker: To containerize applications.
Prometheus: For monitoring metrics from services.
Blackbox Exporter: For probing application availability.
Grafana: For visualizing metrics.
Kubernetes (AWS EKS): For managing containerized workloads.
Terraform: For EKS deployment.

Prerequisites:
- Basic Understanding of CI/CD: Familiarity with Continuous Integration and Continuous Deployment.
- AWS Account: Access to create and manage EC2 instances and EKS.
- Git Knowledge: Experience using Git and GitHub.
- Linux Commands: Basic experience with terminal commands and SSH access.
- Jenkins, Docker, and Kubernetes knowledge: Understanding of basic setup and usage.

Table of Contents:

Step 1: Set up Git Repository and create Security Token
Step 2: Setup required servers (Jenkins, Sonarqube, Nexus, Monitoring tools)
Step 3: Set up Jenkins, Sonarqube and Nexus
Step 4: Install Jenkins Plugins, and Configure Nexus, Trivy, SonarQube and DockerHub to use Jenkins
Step 5: Create a complete CICD pipeline
Step 6: Create the EKS cluster, Install AWS CLI, Kubectl and Terraform
Step 7: Assign a custom domain to the deployed application
Step 8: Monitor the application

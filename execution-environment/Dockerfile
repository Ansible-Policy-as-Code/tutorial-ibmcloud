FROM registry.redhat.io/ansible-automation-platform-22/ee-supported-rhel8:1.0.0

USER root

# Install yum
RUN microdnf install yum

# # Install Terraform, IBM Cloud CLI, and Ansible collections
RUN yum clean all && yum update -y && \
    yum install -y yum-utils && \
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo && \
    yum -y install terraform && \
    curl -fsSL https://clis.cloud.ibm.com/install/linux | sh && \
    ansible-galaxy collection install community.general && \
    ansible-galaxy collection install awx.awx
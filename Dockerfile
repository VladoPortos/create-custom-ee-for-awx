FROM quay.io/ansible/awx-ee:latest

USER root

# add Python dependencies and Ansible
# Galaxy dependencies
ADD requirements.yml /tmp/requirements.yml
ADD requirements.txt /tmp/requirements.txt

# make sure the pip is there and upgrade it
RUN /usr/bin/python3 -m ensurepip && /usr/bin/python3 -m pip install --upgrade pip

# install Ansible Galaxy collections
RUN ansible-galaxy collection install -r /tmp/requirements.yml --collections-path /usr/share/ansible/collections

# install Python dependencies
RUN /usr/bin/python3 -m pip install -r /tmp/requirements.txt

# Add system dependencies
RUN dnf install -y mysql lftp && dnf clean all

# Add terraform
ADD terraform /bin/terraform
RUN chmod +x /bin/terraform


# Add aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

USER 1000

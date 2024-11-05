# Use an Alpine-based image
FROM alpine:latest

# Set the working directory
WORKDIR /root

# Install necessary system packages, including Python, pip, and virtualenv
# Install Ansible dependencies since Alpine needs a few additional packages
RUN apk update && \
    apk add --no-cache \
        ansible \
        python3 \
        py3-pip \
        python3-dev \
        build-base \
        libffi-dev \
        openssl-dev \
        nginx \
        openssh 

# Configure SSH
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

# Copy the application files
COPY app.py .
COPY index.html .
COPY requirements.txt .
COPY playbook.yml .
COPY default.conf .
COPY ssh_keys/rsa.pub .

# Set the PATH to use the virtual environment by default
ENV PATH="/root/venv/bin:$PATH"

# Run the Ansible playbook to set up frontend and backend
RUN ansible-playbook playbook.yml

# Expose necessary ports (80 for nginx and 5000 for Flask backend)
EXPOSE 80 5000 22

# Start both nginx and Flask backend
CMD ["sh", "-c", "nginx && /usr/sbin/sshd && /root/venv/bin/python /root/app.py"]
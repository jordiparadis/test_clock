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
        nginx

# Copy the application files
COPY app.py .
COPY index.html .
COPY requirements.txt .
COPY playbook.yml .

# Copy the Nginx configuration file
COPY default.conf /etc/nginx/http.d/default.conf

# Create and activate a virtual environment, then install dependencies
RUN python3 -m venv /root/venv && \
    /root/venv/bin/pip install --no-cache-dir -r requirements.txt

# Set the PATH to use the virtual environment by default
ENV PATH="/root/venv/bin:$PATH"

# Run the Ansible playbook to set up frontend and backend
RUN ansible-playbook playbook.yml

# Expose necessary ports (80 for nginx and 5000 for Flask backend)
EXPOSE 80 5000

# Start both nginx and Flask backend
CMD ["sh", "-c", "nginx && /root/venv/bin/python /root/app.py"]
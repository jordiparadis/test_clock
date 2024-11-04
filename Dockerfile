# Use a Debian-based image
FROM debian:latest

# Set the working directory
WORKDIR /root

# Install necessary system packages, including Python, pip, and virtualenv
RUN apt-get update && \
    apt-get install -y ansible python3 python3-pip python3-venv && \
    apt-get clean

# Copy the application files
COPY app.py .
COPY index.html .
COPY requirements.txt .
COPY playbook.yml .

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
CMD service nginx start && python3 /root/app.py
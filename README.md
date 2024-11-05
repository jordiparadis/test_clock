
# Clocker Application

This repository contains the code and configurations for a simple web-based clock application called **Clocker**. The application is built with Flask and serves a web page that displays the current time and date. It is hosted with Nginx and includes SSH access for secure management.

## Project Structure

- **app.py**: The main Flask application file that provides the backend API endpoint (`/clock`) to serve the current time in epoch format.
- **index.html**: The frontend HTML file that displays the clock interface. It fetches the time from the Flask API and updates it on the webpage.
- **Dockerfile**: Defines the container environment for running the Clocker application, including installation of necessary packages, configuration of Nginx, and running the Ansible playbook to set up the environment.
- **docker-compose.yml**: Manages multi-container applications with Docker Compose, including configurations for exposing ports and mounting SSH keys.
- **playbook.yml**: Ansible playbook that automates setup tasks such as installing dependencies, configuring Nginx, setting up SSH access, and creating a virtual environment for Python.
- **requirements.txt**: Lists Python dependencies required by the application, including Flask and its extensions.
- **ssh_keys/rsa** and **ssh_keys/rsa.pub**: Private and public SSH keys for secure access to the container. Make sure `rsa` is kept private and secure.

## Prerequisites

- **Docker** and **Docker Compose**: To build and run the application containers.

## Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone <repository_url>
   cd <repository_directory>
   ```

2. **Generate New SSH Keys (Optional)**:
   If you want to use your own SSH keys for access, generate a new key pair and place them in the `ssh_keys` directory, replacing `rsa` and `rsa.pub` files.

3. **Build and Run the Application with Docker Compose**:
   Run the following command to build the Docker image and start the container:
   ```bash
   docker-compose up -d
   ```
   - This will expose:
     - Port `8080` for Nginx (serving the frontend),
     - Port `5001` for Flask (backend API), and
     - Port `2222` for SSH access.

4. **Access the Application**:
   - **Frontend**: Visit `http://localhost:8080` in your browser to see the clock interface.
   - **Backend API**: Access the time API at `http://localhost:5001/clock`.
   - **SSH Access**: Connect via SSH on port `2222` using the following command:
     ```bash
     ssh -i ssh_keys/rsa -p 2222 testuser@localhost
     ```

## File Details

- **index.html**: Contains HTML and JavaScript for the clock's display. It fetches time data from the backend API every 500 milliseconds.
- **playbook.yml**: 
  - Installs necessary packages (Nginx, Python, Flask).
  - Sets up a Python virtual environment and installs Python dependencies.
  - Configures Nginx to serve `index.html`.
  - Creates `testuser` with SSH access, configures SSHD, and disables password authentication.
- **requirements.txt**: Specifies Python packages for the Flask application.
  - Flask (`2.0.1`)
  - Flask-CORS (`3.0.10`)
  - Werkzeug (`2.0.3`)

## Key Docker and Docker Compose Configurations

- **Dockerfile**:
  - Based on Alpine Linux.
  - Installs dependencies via Ansible.
  - Sets up Nginx and the Flask application.
- **docker-compose.yml**:
  - Specifies ports and mounts for SSH keys.
  - Uses `Dockerfile` to build the `app` service.
  - Configures automatic restart on failure.

## Development Notes

- Ensure your `.ssh` directory and `authorized_keys` file inside the container have proper permissions for SSH to work securely:
  - `.ssh` directory: `chmod 700`
  - `authorized_keys` file: `chmod 600`
- Modify `sshd_config` to restrict SSH access to `testuser` and enable public key authentication only.

## Troubleshooting

- If you encounter issues with SSH access, verify the contents of `authorized_keys` and ensure file permissions are correctly set.
- For connectivity problems, ensure ports are not blocked by firewall rules on the host machine.
- Logs can be found in the container’s logs via Docker:
  ```bash
  docker-compose logs app
  ```

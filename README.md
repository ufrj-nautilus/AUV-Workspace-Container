# Table of Contents
1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Troubleshooting](#troubleshooting)

# Prerequisites
## Install Git LFS
<https://git-lfs.github.com/>
## Install Docker and Docker Compose<br />
<https://docs.docker.com/engine/install/><br />
<https://docs.docker.com/compose/install/>
## Generate the SSH keys and store it in your account<br />
<https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent><br />
<https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account>

# Installation
## Clone the entire workspace
    
    git clone https://github.com/ufrj-nautilus/auv_ws.git
    cd auv_ws && ./install.sh
# Usage
## Start the container
    
    cd <your_workspace>/src/auv_ws
    xhost +local:docker
    docker-compose up -d; docker attach auv_ws

# Troubleshooting
##  Slow performance on gazebo with a NVIDIA card
### Add this code block in ```docker-compose.yml``` below the `image` tag
```
deploy:
    resources:
        reservations:
            devices:
                - driver: nvidia
                  capabilities: [gpu]
```
### Add the ```docker-compose.yml``` in the ```.gitignore```
```
echo "docker-compose.yml" >> .gitignore
```

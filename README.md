# ✔️ Prerequisites
## Install Git LFS
<https://docs.github.com/pt/repositories/working-with-files/managing-large-files/installing-git-large-file-storage/>
## Install Docker and Docker Compose<br />
<https://docs.docker.com/engine/install/><br />
<https://docs.docker.com/compose/install/>
## Generate the SSH keys and store it in your account<br />
<https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent><br />
<https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account>
# 🏁 Install and Run
## Clone the entire workspace
    
    git clone https://github.com/ufrj-nautilus/auv_ws.git
    cd auv_ws && ./install.sh
## Start the container
    
    cd <your_workspace>/src/auv_ws
    xhost +local:docker
    docker-compose up -d; docker attach auv_ws
# :bug: Troubleshooting
##  Slow performance on gazebo with a NVIDIA card
### Add this code block below the `image` tag
```
 deploy:
    resources:
      reservations:
        devices:
        - driver: nvidia
          capabilities: [gpu]
```
### Add the ```docker-compose.yml``` in the ```.gitignore```

# How to setup the development environment of the AUV.
## Install Docker and Docker Compose.
<https://docs.docker.com/engine/install/>
<https://docs.docker.com/compose/install/>
## Be sure to have the ssh keys on your system and on your account, if not:
<https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent>
<https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account>
## If you don't have the workspace already on your system, you can use the script on this repo to clone everything.
    git clone https://github.com/ufrj-nautilus/auv_ws.git
    cd auv_ws && ./install.sh
## Start the container
    cd <your_workspace>/src/auv_ws; docker-compose up -d; docker attach auv_ws

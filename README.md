# Prerequisites
- Install Docker and Docker Compose.<br />
<https://docs.docker.com/engine/install/><br />
<https://docs.docker.com/compose/install/>
- Generate the SSH keys and store it in your account.<br />
<https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent><br />
<https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account>
# Install
    # Clone the entire workspace.
    git clone https://github.com/ufrj-nautilus/auv_ws.git
    cd auv_ws && ./install.sh
    
    # Start the container.
    cd <your_workspace>/src/auv_ws; docker-compose up -d; docker attach auv_ws

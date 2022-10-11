#!/bin/bash
distro_filter=$(uname -r | tr '[:upper:]' '[:lower:]')
distro=$(grep -E '^(PRETTY_NAME|NAME)=' /etc/os-release)
BOLD=$(tput bold)
RED='\033[0;31m'
YELLOW='\033[1;33m'
NORMAL='\033[0m'

pull_codebase(){
echo -e "\nChoose where you want to store the AUV workspace, leave it blank for $HOME/catkin_ws"
echo -n "mkdir -p $HOME/"
read workspace

mkdir -p $HOME/$workspace/catkin_ws/src
cd $HOME/$workspace/catkin_ws/src
mkdir -p $HOME/$workspace/catkin_ws/src/robots
mkdir -p $HOME/$workspace/catkin_ws/src/actuators

repo_list=(
   "gripper"
   "marker_dropper"
   "torpedo"
   "auv_simulator"
   "control"
   "brhue"
   "lua"
   "utils"
   "auv_messages"
   "localization"
   "smach"
   "auv_ws"
)
for repo in ${repo_list[@]}; do
   git clone git@github.com:ufrj-nautilus/$repo.git
done

mv gripper actuators/
mv marker_dropper actuators/
mv torpedo actuators/

mv brhue robots/
mv lua robots/

git clone --recursive git@github.com:ufrj-nautilus/darknet_ros.git
git clone --branch noetic-devel git@github.com:tdenewiler/uuv_simulator.git

cd utils
rm -rf pysdf
git rm --cached pysdf
git submodule add https://github.com/ufrj-nautilus/pysdf
}

find_distro(){
if [[ $distro == *'Arch'* ]] || [[ $distro == *'Manjaro'* ]]; then
   yes | sudo pacman -S git-lfs docker docker-compose
   sudo systemctl start docker
   sudo systemctl enable docker
elif [[ $distro == *'Ubuntu'* ]] || [[ $distro == *'Debian'* ]] || [[ $distro == *'Mint'* ]]; then
   sudo apt-get install git-lfs docker docker-compose -y
elif [[ $distro == *'Fedora'* ]]; then
   sudo dnf install dnf-plugins-core 
   sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
   sudo dnf install docker-ce docker-ce-cli containerd.io git-lfs docker-compose -y
   sudo systemctl start docker
   sudo systemctl enable docker
elif [[ $distro == *'openSUSE'* ]]; then
   sudo zypper install docker python3-docker-compose git-lfs
   sudo systemctl enable docker
else
   echo "Distro not found"
   exit
fi
}

echo -n "Enter your github email: "
read email

if [ -f "$HOME/.ssh/id_rsa.pub" ]; then
   cat $HOME/.ssh/id_rsa.pub
else 
   ssh-keygen -t rsa -b 4096 -C $email
   eval "$(ssh-agent -s)"
   ssh-add $HOME/.ssh/id_rsa
   cat $HOME/.ssh/id_rsa.pub
fi
echo -e "\n## ==> https://github.com/settings/ssh/new\n"
echo -e "${YELLOW}Did you register the key?${NORMAL}"
sleep 3
select ans in "Yes" "No"; do
   case $ans in
      Yes )
         break;;
      No )
         exit;;
   esac
done
eval `ssh-agent`
ssh-add

if [[ $distro_filter == *'microsoft'* ]]; then
   find_distro
   git lfs install
   pull_codebase
   echo -e "#####\n#####\n## ==> ${YELLOW}Install Docker Desktop:${NORMAL} https://www.docker.com/products/docker-desktop/\n#####\n#####"
   exit
else
   find_distro
fi

git lfs install
sudo groupadd docker
sudo usermod -aG docker $USER
xhost +local:docker
pull_codebase
echo -e "#####\n#####\n##${RED} WARNING:${NORMAL} You need to run ${BOLD}xhost +local:docker${NORMAL} on every boot.\n#####\n#####"

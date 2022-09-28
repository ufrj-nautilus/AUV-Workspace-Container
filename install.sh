#!/bin/bash
echo -n "Enter your github email: "
read email

if [ -f "$HOME/.ssh/id_rsa.pub" ]; then
   sudo cp $HOME/.ssh/id_rsa.pub $HOME/sshkey.txt
else
   ssh-keygen -t rsa -b 4096 -C $email
   eval "$(ssh-agent -s)"
   ssh-add $HOME/.ssh/id_rsa
   sudo cp $HOME/.ssh/id_rsa.pub $HOME/sshkey.txt
fi
echo ""
echo $(cat $HOME/sshkey.txt)
echo -e "\nssh public key: $HOME/sshkey.txt\n"
echo -e "=======> https://github.com/settings/ssh/new\n"

echo "Did you register the key?"
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

check=$(grep -E '^(VERSION|NAME)=' /etc/os-release)
arch='Arch'
ubuntu='Ubuntu'
fedora='Fedora'
debian='Debian'

if [[ $check == *$arch* ]]; then
   yes | sudo pacman -S git-lfs docker docker-compose
   sudo systemctl start docker
   sudo systemctl enable docker

elif [[ $check == *$ubuntu* ]] || [[ $check == *$debian* ]]; then
   sudo apt-get install git-lfs docker docker-compose -y

elif [[ $check == *$fedora* ]]; then
   sudo dnf install dnf-plugins-core 
   sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
   sudo dnf install docker-ce docker-ce-cli containerd.io git-lfs docker-compose -y
   sudo systemctl start docker
   sudo systemctl enable docker

else
   echo "Distro not found"
   exit
fi
xhost +local:docker

## INSTALL
echo ""
echo "###"
echo "Choose where you want to store the AUV workspace, leave it blank for $HOME/catkin_ws"
echo "###"
echo -n "mkdir -p $HOME/"
read workspace

mkdir -p $HOME/$workspace/catkin_ws/src
cd $HOME/$workspace/catkin_ws/src
mkdir -p $HOME/$workspace/catkin_ws/src/robots
mkdir -p $HOME/$workspace/catkin_ws/src/actuators

r=(
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
for gg in ${r[@]}; do
   git clone git@github.com:ufrj-nautilus/$gg.git
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

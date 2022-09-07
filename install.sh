#!/bin/bash
echo ":: Preparing your environment ::"
echo ""
echo -n "What is your username (local user)? "
read user
echo -n "Enter your github email: "
read email

echo "Which ssh key do you want?"
select key in "rsa" "ed25519"; do
   case $key in
      rsa )
         key=rsa break;;
      ed25519 )
         key=ed25519 break;;
   esac
done

if [ -f "/home/$user/.ssh/id_$key.pub" ]; then
   sudo cp /home/$user/.ssh/id_$key.pub /home/$user/sshkey.txt
else
   ssh-keygen -t $key -b 4096 -C $email
   eval "$(ssh-agent -s)"
   ssh-add /home/$user/.ssh/id_$key
   sudo cp /home/$user/.ssh/id_$key.pub /home/$user/sshkey.txt
fi
echo ""
echo $(cat /home/$user/sshkey.txt)
echo ""
echo "Your ssh public key is in the home, named as \"sshkey\""
echo "do it =======> https://github.com/settings/ssh/new"
echo ""

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

check=$(egrep '^(VERSION|NAME)=' /etc/os-release)
arch='Arch'
ubuntu='Ubuntu'
alpine='Alpine'
fedora='Fedora'
debian='Debian'

if [[ $check == *$arch* ]]; then
   sudo pacman -S git-lfs docker docker-compose

elif [[ $check == *$ubuntu* ]] || [[ $check == *$debian* ]]; then
   sudo apt-get install git-lfs docker docker-compose

elif [[ $check == *$alpine* ]]; then
   sudo apk add git-lfs docker docker-compose

elif [[ $check == *$fedora* ]]; then
   sudo dnf install dnf-plugins-core 
   sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
   sudo dnf install docker-ce docker-ce-cli containerd.io git-lfs docker-compose
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

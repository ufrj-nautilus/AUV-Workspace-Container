#!/bin/bash
echo "Preparing your environment"
echo ""
echo ""
echo -n "What is your username?"
read user
echo -n "Enter your github email "
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

check=$(egrep '^(VERSION|NAME)=' /etc/os-release)
arch='Arch'
ubuntu='Ubuntu'
alpine='Alpine'
fedora='Fedora'
debian='Debian'
mint='Mint'

if [[ $check == *$arch* ]]; then
   yes | sudo pacman -S git-lfs docker docker-compose
   if [ -f "/home/$user/.ssh/id_$key.pub" ]; then
      sudo cp /home/$user/.ssh/id_$key.pub /home/$user/sshkey.txt
      echo "Your ssh public key is in the home, named as \"sshkey\""
      echo "do it: https://github.com/settings/ssh/new"
   else
      ssh-keygen -t $key -b 4096 -C $email
      eval "$(ssh-agent -s)"
      ssh-add /home/$user/.ssh/id_$key
      sudo cp /home/$user/.ssh/id_$key.pub /home/$user/sshkey.txt
      echo "Your ssh public key is in the home, named as \"sshkey\""
      echo "do it: https://github.com/settings/ssh/new"
   fi
else
   echo "Arch isnt your distro XD"
fi

## git clone https://github.com/ufrj-nautilus/auv_ws.git
## cd auv_ws && ./install.sh
## xhost +local:docker

#!/bin/bash

ARCH=`dpkg --print-architecture`
if [ $ARCH = 'i386' ]; then
	ZIP='HabboFlash_Release3_Linux_x86';
elif [ $ARCH = 'amd64' ]; then
	ZIP='HabboFlash_Release3_Linux_x64';
elif [ $ARCH = 'arm32' ] || [ $ARCH = 'armhf' ]; then
	ZIP='HabboFlash_Release3_Linux_ARM32';
elif [ $ARCH = 'arm64' ]; then
	echo "[Adding ARMHF architecture]"
	sudo dpkg --add-architecture armhf
	sudo apt-get update
	sudo apt-get install libc6:armhf libstdc++6:armhf
	cd /lib
	sudo ln -s arm-linux-gnueabihf/ld-2.23.so ld-linux.so.3
	ZIP='HabboFlash_Release3_Linux_ARM32';
fi

cd "$(cd "$(dirname "$0")" && pwd)" #Set current path to script path

echo "[Checking dependencies]"
pkgs='unzip wget libnss3'
for pkg in $pkgs; do
    if type dpkg &>/dev/null; then
        if [ -z "$(dpkg --list | grep "$pkg")" ]; then
            sudo apt install $pkg -y
        fi
    else
        if [ -z "$(pacman -Q | grep "$pkg")" ]; then
            sudo pacman -S $pkg --noconfirm
        fi
    fi
done

HabboFlashForLinuxAppPath=~/.local/share/applications/HabboFlashForLinux
#rm -r $HabboFlashForLinuxAppPath
mkdir -p $HabboFlashForLinuxAppPath
mkdir -p ~/.icons
echo "[Downloading client]"
wget https://github.com/LilithRainbows/HabboFlash/releases/download/releas3_u2/$ZIP.zip -O $HabboFlashForLinuxAppPath/$ZIP.zip
echo "[Extracting client]"
unzip -o $HabboFlashForLinuxAppPath/$ZIP.zip -d $HabboFlashForLinuxAppPath
mv -v $HabboFlashForLinuxAppPath/$ZIP/* $HabboFlashForLinuxAppPath
rm -r $HabboFlashForLinuxAppPath/$ZIP
chmod +x $HabboFlashForLinuxAppPath/HabboFlash
wget https://github.com/LilithRainbows/HabboFlash/raw/main/HabboFlashForLinux.png -O ~/.icons/HabboFlashForLinux.png
wget https://github.com/LilithRainbows/HabboFlash/raw/main/HabboFlashForLinux.desktop -O $HabboFlashForLinuxAppPath/../HabboFlashForLinux.desktop
rm $HabboFlashForLinuxAppPath/$ZIP.zip

echo "Client installation finished. A shortcut for HabboFlashForLinux will appear on your system."

# Optional: remove this installation script.
rm $0

#Script base credits: https://github.com/belieb/

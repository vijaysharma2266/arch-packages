#!/bin/bash

rm temp.txt
touch temp.txt


udef_setdns()
{
    ping -c 1 google.com
    if [ $? -ne 2 ]
    then
        echo "nameserver properly configured"
    else
        echo "nameserver not configured"
        echo "nameserver 8.8.8.8" >> /etc/resolv.conf
        ping -c 1 google.com
        if [ $? -eq 0 ]
        then
            echo "nameserver configured"
        else
            echo "can't configure nameserver" >> temp.txt
        fi
    fi
}
udef_setdns


sed -i "s/Required DatabaseOptional/Never/g" /etc/pacman.conf
pacman -S wget
 
#wget https://github.com/binhex/arch-packages/raw/master/compiled/apacman-3.1-1-any.pkg.tar.xz
git clone https://github.com/lokeshyadav2110/Arch-Packages.git 
pacman -U Arch-Packages/apacman-3.0-1-any.pkg.tar.xz
pacman -U Arch-Packages/python2-2.7.18-8-x86_64.pkg.tar.zst
pacman -U Arch-Packages/python2-gobject2-2.28.7-7-x86_64.pkg.tar.zst
pacman -U Arch-Packages/python2-linux-procfs-0.5.1-4-any.pkg.tar.xz
pacman -S gcc-fortran
pacman -S ttf-dejavu

#wget https://cran.r-project.org/src/contrib/quadprog_1.5-8.tar.gz
#wget https://cran.r-project.org/src/contrib/quadprog_1.5-8.tar.gz
#sudo R CMD INSTALL quadprog_1.5-8.tar.gz

#wget https://cran.r-project.org/src/contrib/Archive/tseries/tseries_0.10-46.tar.gz
#sudo R CMD INSTALL tseries_0.10-46.tar.gz
#R
#install.packages("data.table")
#install.packages("xtable")
#install.packages("zoo")
#install.packages("bit64")
#install.packages("R.utils")
#install.packages("tseries")


#wget http://ftp5.gwdg.de/pub/linux/archlinux/community/os/x86_64//python2-linux-procfs-0.5.1-4-any.pkg.tar.xz
#pacman -U python2-linux-procfs-0.5.1-4-any.pkg.tar.xz
apacman -S --noconfirm tuned tcpdump dmidecode lshw gperftools gentoo-bashrc mprime sfnettest openbsd-netcat lm_sensors
systemctl enable tuned.service
tuned-adm profile network-latency

udef_setskel()
{
    TESTFILENAME=$(date +"%Y%m%d.%H%M%S")
    FILE=/etc/skel/.bashrc
    cat << EOF > "${TESTFILENAME}"
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ \$- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\\$ '
EOF
    diff "${TESTFILENAME}"  "${FILE}"
    if [ $? -ne 0 ]
    then
        echo "default $FILE is incorrect" >> temp.txt
    else
        echo "source /usr/share/gentoo-bashrc/bashrc" >> "${FILE}"
        echo "source /usr/share/doc/pkgfile/command-not-found.bash" >> "${FILE}"
        echo "export PATH=/home/trading/util/:/home/trading/scripts/:\$PATH" >> "${FILE}"
        echo "export EDITOR=vim" >> "${FILE}"
        echo "alias vi='vim'" >> "${FILE}"
        #rsync -a /etc/skel/ /root/
    fi
    cat "${FILE}"
}

udef_setskel

cat << EOF > /root/.bashrc
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ \$- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
source /usr/share/gentoo-bashrc/bashrc
#source /usr/share/doc/pkgfile/command-not-found.bash
export PATH=/home/trading/util/:/home/trading/scripts/:\$PATH
export EDITOR=vim
alias vi='vim'
EOF

cat << EOF > /root/.bash_profile
#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
EOF

cat temp.txt


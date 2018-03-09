#/bin/bash

cd ~
echo "**********************************************************************"
echo "*                                                                    *"
echo "*                                                                    *"
echo "*********************  I'm here to help you :) ***********************"
echo "*                                                                    *"
echo "*                                                                    *"
echo "**********************************************************************"
echo "*                                                                    *"
echo "*         We are going to install your MYCE masternode             *"
echo "*                                                                    *"
echo "**********************************************************************"
echo && echo && echo


sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libboost-all-dev libdb4.8-dev libdb4.8++-dev libminiupnpc-dev libzmq3-dev tmux
sudo apt-get install -y libgmp3-dev

sudo apt-get update

cd /var
sudo touch swap.img
sudo chmod 600 swap.img
sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
sudo mkswap /var/swap.img
sudo swapon /var/swap.img
sudo free
sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
cd

sudo apt-get install -y ufw
sudo ufw allow ssh/tcp
sudo ufw logging on
#sudo ufw enable
sudo ufw status

mkdir -p ~/bin
echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
source ~/.bashrc


git clone https://github.com/mycelliumcoin/MycelliumMN
cd MycelliumMN/src/leveldb && chmod 777 * && cd .. && make -f makefile.unix

cd ~/myce/src
./myced


echo ""
echo "**********************************************************************"
echo ""
echo "Let's configure your masternodes..."
echo "Type the IP of this server (it's located on your dashboard) then press [ENTER]:"
read IP
hostname -I
echo ""
echo "**********************************************************************"
echo ""
echo "Type the PORT your going to use on this server (port: 23511 recommended for MYCE) then press [ENTER]:"
read PORT

#echo ""
#echo "**********************************************************************"
#echo ""
#echo "Enter your masternode private key then press [ENTER]:"
PRIVKEY=./myced genkey
./myced stop

echo ""
echo "**********************************************************************"
echo ""
echo "                          Thanks I'll continue                        "
echo ""
echo "**********************************************************************"
echo ""


CONF_DIR=~/.myce/
CONF_FILE=myce.conf

echo "rpcuser=rpccheese"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=rpccheesepass"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "logtimestamps=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "masternode=1" >> $CONF_DIR/$CONF_FILE
echo "" >> $CONF_DIR/$CONF_FILE

#echo "addnode=127.0.0.1" >> $CONF_DIR/$CONF_FILE

echo "" >> $CONF_DIR/$CONF_FILE
echo "port=$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternodeaddress=$IP:$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternodeprivkey=$PRIVKEY" >> $CONF_DIR/$CONF_FILE
sudo ufw allow $PORT/tcp

./myce -daemon
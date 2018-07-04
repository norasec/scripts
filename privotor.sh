#!/bin/sh

apt-get install tor privoxy

#disable tor and privoxy autostart and stop services
update-rc.d tor disable
update-rc.d privoxy disable
service tor stop
service privoxy stop

#change permissions /var/lib/tor
chown root:root /var/lib/tor

#first tor bydefault, first privo add
echo 'forward-socks4 / 127.0.0.1:9050 .' >> /etc/privoxy/config
echo 'forward-socks4a / 127.0.0.1:9050 .' >> /etc/privoxy/config
echo 'forward-socks5 / 127.0.0.1:9050 .' >> /etc/privoxy/config

for i in 2 3 4 5
do
#LOG NEEDED FOLDERS
mkdir /var/log/privoxy$i
chown privoxy:adm /var/log/privoxy$i
#TOR CONFIGS
touch /etc/tor/torrc$i
echo 'SocksPort 9'$(($i-1))'50' >> /etc/tor/torrc$i
echo 'DataDirectory /var/lib/tor'$i >> /etc/tor/torrc$i
echo 'ControlPort 9'$(($i-1))'51' >> /etc/tor/torrc$i
#PRIVOXY CONFIGS
touch /etc/privoxy/config$i
echo 'logdir /var/log/privoxy'$i >> /etc/privoxy/config$i
echo 'listen-address localhost:8'$i'18' >> /etc/privoxy/config$i
echo 'forward-socks4 / 127.0.0.1:9'$(($i-1))'50 .' >> /etc/privoxy/config$i
echo 'forward-socks4a / 127.0.0.1:9'$(($i-1))'50 .' >> /etc/privoxy/config$i
echo 'forward-socks5 / 127.0.0.1:9'$(($i-1))'50 .' >> /etc/privoxy/config$
done

#ADDING NODE EXIT COUNTRIES
echo 'StrictExitNodes 1' >> /etc/tor/torrc2
echo 'ExitNodes {us}' >> /etc/tor/torrc2
echo 'StrictExitNodes 1' >> /etc/tor/torrc3
echo 'ExitNodes {ru}' >> /etc/tor/torrc3
echo 'StrictExitNodes 1' >> /etc/tor/torrc4
echo 'ExitNodes {br}' >> /etc/tor/torrc4

#MAKING SCRIPT FOR START ALL PRIVO/TORS
cd ~/
touch TorUp.sh
echo '#!/bin/sh' >> ~/TorUp.sh
echo '#RUN TORS' >> ~/TorUp.sh
echo 'tor -f /etc/tor/torrc &' >> ~/TorUp.sh
echo 'tor -f /etc/tor/torrc2 &' >> ~/TorUp.sh
echo 'tor -f /etc/tor/torrc3 &' >> ~/TorUp.sh
echo 'tor -f /etc/tor/torrc4 &' >> ~/TorUp.sh
echo 'tor -f /etc/tor/torrc5 &' >> ~/TorUp.sh
echo '#RUN PRIVOXYS' >> ~/TorUp.sh
echo '/usr/sbin/privoxy --pidfile /var/run/privoxy.pid /etc/privoxy/config' >> ~/TorUp.sh
echo '/usr/sbin/privoxy --pidfile /var/run/privoxy2.pid /etc/privoxy/config2' >> ~/TorUp.sh
echo '/usr/sbin/privoxy --pidfile /var/run/privoxy3.pid /etc/privoxy/config3' >> ~/TorUp.sh
echo '/usr/sbin/privoxy --pidfile /var/run/privoxy4.pid /etc/privoxy/config4' >> ~/TorUp.sh
echo '/usr/sbin/privoxy --pidfile /var/run/privoxy5.pid /etc/privoxy/config5' >> ~/TorUp.sh

#ADDING TO BASHRC
echo "alias torprivo='sudo sh TorUp.sh'" >> ~/.bashrc

# Run from /opt

# Installation od iC880a Driver
sudo mkdir /opt/lora_gateway
sudo chown -R pi:pi /opt/lora_gateway
git clone https://github.com/Lora-net/lora_gateway.git /opt/lora_gateway
cd /opt/lora_gateway
sudo make

# Installation of LoRa Semtech UDP Forwarder daemon
sudo mkdir /opt/packet_forwarder
sudo chown -R pi:pi /opt/packet_forwarder
git clone https://github.com/Lora-net/packet_forwarder.git /opt/packet_forwarder

ip link show eth0 | awk '/ether/ {print $2}' | awk -F ':' '{print $1$2$3"FFFE"$4$5$6}' | tr [:lower:] [:upper:] > /opt/packet_forwarder/gatewayID.txt
cd /opt/packet_forwarder
sudo make

sed -i "s/AA555A0000000101/$(cat gatewayID.txt)/" lora_pkt_fwd/local_conf.json
sed -i "s/localhost/193.87.2.13/" lora_pkt_fwd/global_conf.json
sed -i "s/1680/8005/" lora_pkt_fwd/global_conf.json
cd /opt/packet_forwarder/lora_pkt_fwd
nohup ./lora_pkt_fwd < /dev/null 2> error.log > out.log &

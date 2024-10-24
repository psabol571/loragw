#!/bin/bash

sudo tee /etc/systemd/system/lora_pkt_fwd.service << 'EOF'
[Unit]
Description=LoRa Packet Forwarder daemon

[Service]
WorkingDirectory=/opt/packet_forwarder/lora_pkt_fwd
ExecStartPre=/opt/lora_gateway/reset_lgw.sh start 25
ExecStart=/opt/packet_forwarder/lora_pkt_fwd/lora_pkt_fwd
SyslogIdentifier=lora_pkt_fwd
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable lora_pkt_fwd.service
sudo systemctl start lora_pkt_fwd.service

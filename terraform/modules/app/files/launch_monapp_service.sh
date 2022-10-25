#!/usr/bin/env bash
cat << EOF | sudo tee -a /etc/systemd/system/monapp.service
[Unit]
Description= Launch reddit application
After=mongod

[Service]
EnvironmentFile=/etc/default/puma
Type=simple
User=appuser
WorkingDirectory=/home/appuser/reddit
ExecStart=/usr/local/bin/puma
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable monapp.service
sudo systemctl start monapp.service
sudo systemctl status monapp.service

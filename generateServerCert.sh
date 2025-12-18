#!/bin/bash
# Author afmart
# run to create MQTT Broker PKI certificate key pair
docker run --rm -it \
  -v $PWD/ca:/home/step \
  -v $PWD/mqtt-broker:/tmp \
  smallstep/step-ca \
  step ca certificate \
    "mqtt-broker" \
    /tmp/broker.crt \
    /tmp/broker.key \
    --kty EC \
    --curve P-256 \
    --san mqtt-broker \
    --san mqtt-broker.local \
    --provisioner admin \
    --password-file /home/step/secrets/password.txt \
    --ca-config /home/step/config/ca.json \
    --root /home/step/certs/root_ca.crt \
    --offline

#!/bin/bash
# Author afmart
# run to create subscriber pki certificate key pair

docker run --rm -it \
  -v $PWD/ca:/home/step \
  -v $PWD/subscriber:/tmp \
  smallstep/step-ca \
  step ca certificate \
    "subscriber" \
    /tmp/subscriber.crt \
    /tmp/subscriber.key \
    --kty EC \
    --curve P-256 \
    --san subscriber \
    --san subscriber.local \
    --provisioner admin \
    --password-file /home/step/secrets/password.txt \
    --ca-config /home/step/config/ca.json \
    --root /home/step/certs/root_ca.crt \
    --offline

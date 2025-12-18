#!/bin/bash
# Author afmart
# run to create publisher pki certificate key pair

docker run --rm -it \
  -v $PWD/ca:/home/step \
  -v $PWD/publisher:/tmp \
  smallstep/step-ca \
  step ca certificate \
    "publisher" \
    /tmp/publisher.crt \
    /tmp/publisher.key\
    --kty EC \
    --curve P-256 \
    --san publisher \
    --san publisher.local \
    --provisioner admin \
    --password-file /home/step/secrets/password.txt \
    --ca-config /home/step/config/ca.json \
    --root /home/step/certs/root_ca.crt \
    --offline
#!/bin/bash
# Author afmart
# run to bootstrap smallstep CA and create a new ca/config/ca.json and root_ca.crt

docker run --rm -it \
  -v $PWD/ca:/home/step \
  smallstep/step-ca \
  step ca init \
    --name "IoT TLS CA" \
    --dns localhost \
    --address ":9000" \
    --provisioner admin \
    --password-file /home/step/secrets/password.txt

cat  $PWD/ca/certs/intermediate_ca.crt $PWD/ca/certs/root_ca.crt | tee $PWD/ca/certs/ca_bundle.crt

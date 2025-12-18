#!/bin/bash
set -e

OUT="/output"

mkdir -p "$OUT/secrets"
mkdir -p "$OUT/certs"

# 1. Generate Random Password if it doesn't exist
if [ ! -f "$OUT/secrets/password.txt" ]; then
    echo "Generating new CA password..."
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 | tee "$OUT/secrets/password.txt"
fi

# 2. Initialize the CA inside the mount
export STEPPATH="$OUT/IoT-CA"

if [ ! -d "$STEPPATH" ]; then
    echo "Initializing CA backend..."
    step ca init \
        --name "IoT-Private-CA" \
        --dns "localhost" \
        --address ":9000" \
        --provisioner "admin" \
        --password-file "$OUT/secrets/password.txt" 
fi

# 3. Generate Device Certs
for device in mqtt-broker publisher subscriber ; do
    echo "Generating certs for $device..."
    
    step ca certificate "${device}" \
        "$OUT/certs/$device.crt" \
        "$OUT/secrets/$device.key" \
        --kty EC \
        --curve P-256 \
        --san ${device} \
        --san ${device}.local \
        --provisioner admin \
        --password-file "$OUT/secrets/password.txt" \
        --ca-config "$STEPPATH/config/ca.json" \
        --root "$STEPPATH/certs/root_ca.crt" \
        --offline # certificates are issued for 30 only.
done

cat "$STEPPATH/certs/intermediate_ca.crt" "$STEPPATH/certs/root_ca.crt" | tee -a "$OUT/certs/ca_bundle.crt"

echo "Done! Certificates generated in $OUT/certs"
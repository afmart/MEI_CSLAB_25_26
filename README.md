# MEI_CSLAB_25_26 

## Secure IoT MQTT Demo (mTLS + ASCON)

This repository contains a workshop created for a final evaluation in a cybersecurity lab, demonstrating how to implement End-to-End Encryption using NIST’s Lightweight Cryptography ASCON to simulate an IoT scenario. 

This project uses Docker and Python to showcase a **secure IoT MQTT messaging ** workflow.

### The system consists of:

- A **MQTT broker (Eclipse Mosquitto)**
- A **MQTT publisher (python paho)** publishing encrypted temperature and humidity data
- A **MQTT subscriber (python paho)** decrypting and reading that data

### Features:

- **ASCON (AEAD)** for lightweight payload encryption.
- **Mutual TLS (mTLS)** for device authentication.
- **Docker Compose** for easy deployment.

# How to use:

 - Clone this repository 
 - Generate CA and key par certificates for mktt-broker, publisher and subscriber.
 - Create an environment file to provide ASCON configuration to both publisher and subscriber.


## TLS Certificate Generation (StepCA Docker)

- Go to ca folder.
- Build the Dockerfile.
- Run it mounting the current forder as output. 

On unix based systems
```
cd ca/
docker build -t "cert-gen" .
docker run -it --rm -v $(pwd):/output cert-gen
```

On windows (Powershell)
```
cd ca/
docker build -t "cert-gen" .
docker run -it --rm -v ${pwd}:/output cert-gen
```

## Environment File (.env)

create .env file for ASCON_KEY, NONCE_TEMP, NONCE_HUM

- ASCON_KEY must be 16 bytes (32 hex characters)
- Nonces must be unique per topic
- This setup uses static nonces for demo purposes only
- Do not reuse nonces in real systems

```
ASCON_KEY=00112233445566778899aabbccddeeff
NONCE_TEMP=00000000000000000000000000000001
NONCE_HUM =00000000000000000000000000000002
```

## Run the lab

- Build composer dependencies
- Set composer up

```
docker compose build
docker compose up 
```
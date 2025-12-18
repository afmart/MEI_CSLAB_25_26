import os, ssl, time
import paho.mqtt.client as mqtt
from ascon import encrypt

KEY = bytes.fromhex(os.environ["ASCON_KEY"])
NONCE_TEMP = bytes.fromhex(os.environ["NONCE_TEMP"])
NONCE_HUM  = bytes.fromhex(os.environ["NONCE_HUM"])

def enc(value, nonce):
    return encrypt(KEY, nonce, b"0", value.encode())

client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)

client.tls_set(
    ca_certs="/run/secrets/ca_cert",
    certfile="/run/secrets/publisher_cert",
    keyfile="/run/secrets/publisher_key",
)

client.connect("mqtt-broker", 8883)

while True:
    cipher = enc("22.9", NONCE_TEMP)
    #print("Message 22.9 to temp, Publishing bytes:", cipher, len(cipher))
    
    client.publish("roomA/temp", cipher )
    time.sleep(5)
    cipher = enc("45.1", NONCE_HUM)
    #print("Message 45.1 to hum, Publishing bytes:", cipher, len(cipher))
    client.publish("roomA/hum",  cipher)
    time.sleep(10)

import os, ssl
import paho.mqtt.client as mqtt
from ascon import decrypt

KEY = bytes.fromhex(os.environ["ASCON_KEY"])
NONCE_TEMP = bytes.fromhex(os.environ["NONCE_TEMP"])
NONCE_HUM  = bytes.fromhex(os.environ["NONCE_HUM"])

def dec(payload, nonce):
    print("Decoding message, bytes:", payload, len(payload))
    if len(payload) < 16:
        return "<invalid>"  # simple safeguard
    return decrypt(KEY, nonce, b"0", payload ).decode()

"""def on_message(client, userdata, msg):
    print(f"Received {msg.topic}, payload bytes ({len(msg.payload)}):", msg.payload)
    try: 
        if msg.topic.endswith("temp"):
            print("TEMP:", dec(msg.payload, NONCE_TEMP))
        elif msg.topic.endswith("hum"):
            print("HUM :", dec(msg.payload, NONCE_HUM))
        else:
            print("Other topic:", msg.topic, msg.payload)
    except Exception as e:
        print("Error decoding message:", msg.topic, msg.payload, e)
"""

def on_message_temp (mosq, obj, msg):
    #print(f"Received {msg.topic}, payload bytes ({len(msg.payload)}):", msg.payload)
    try:
        print("TEMP :", str(dec(msg.payload, NONCE_TEMP)))
    except Exception as e:
        print("Error decoding message:", msg.topic, msg.payload, e)


def on_message_hum (mosq, obj, msg):
    #print(f"Received {msg.topic}, payload bytes ({len(msg.payload)}):", str(msg.payload))
    try:
        print("HUM :", str(dec(msg.payload, NONCE_HUM)))
    except Exception as e:
        print("Error decoding message:", msg.topic, msg.payload, e)



client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)

client.tls_set(
    ca_certs="/run/secrets/ca_cert",
    certfile="/run/secrets/subscriber_cert",
    keyfile="/run/secrets/subscriber_key"
)

client.message_callback_add("roomA/temp", on_message_temp)
client.message_callback_add("roomA/hum", on_message_hum)
#client.on_message = on_message
client.connect("mqtt-broker", 8883)
client.subscribe("roomA/#")

client.loop_forever()


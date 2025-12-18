FROM smallstep/step-ca:latest

USER root
WORKDIR /toolkit

# Install any extra tools if needed (step-ca image is based on Debian/Alpine)
# Copy the generation script into the image
COPY generate.sh .
RUN chmod +x generate.sh

# This container will wait for you to run it with a volume mount
ENTRYPOINT ["./generate.sh"]

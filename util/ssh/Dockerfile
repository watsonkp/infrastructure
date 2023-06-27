FROM alpine

# Install SSH client and server. Client is required for scp.
RUN apk add --no-cache openssh

RUN mkdir /run/sshd

# Create necessary home directories for ssh
WORKDIR /root
RUN mkdir .ssh
RUN chmod 0700 .ssh

EXPOSE 22/tcp
CMD ["/usr/sbin/sshd", "-D", "-e", "-p", "22"]

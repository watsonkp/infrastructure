FROM alpine

# Install git and SSH server
RUN apk add --no-cache git openssh-server

# Setup git user
RUN adduser git --disabled-password --shell /usr/bin/git-shell
RUN sed -i -e 's/git:!/git:*/' /etc/shadow

# Create repository path
RUN mkdir -p /srv/git
RUN chown -R git:git /srv/git

RUN mkdir /run/sshd

# Switch to git user to configure its SSH access.
USER git

# Create necessary home directories for ssh
WORKDIR /home/git
RUN mkdir .ssh
RUN chmod 0700 .ssh

# Add custom git commands to allow remote initialization and git protocol export.
COPY git-shell-commands git-shell-commands

# Switch back to root user to restrict permissions and run the server
USER root

EXPOSE 22/tcp
CMD ["/usr/sbin/sshd", "-D", "-e", "-p", "22"]

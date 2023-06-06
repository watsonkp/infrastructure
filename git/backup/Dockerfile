FROM alpine

RUN apk add --no-cache openssh git
RUN mkdir /container
RUN mkdir /data

# Add backup scripts
COPY ./backup-git.sh /container/backup-git.sh
COPY ./backup-youtrack.sh /container/backup-youtrack.sh
COPY ./restore-youtrack.sh /container/restore-youtrack.sh

RUN chmod +x /container/backup-git.sh
RUN chmod +x /container/backup-youtrack.sh
RUN chmod +x /container/restore-youtrack.sh

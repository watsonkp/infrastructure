FROM alpine

RUN apk add --no-cache openssh git
RUN mkdir /container
RUN mkdir /data
COPY ./git.sh /container/git.sh

RUN chmod +x /container/git.sh

ENTRYPOINT ["/container/git.sh"]

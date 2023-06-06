FROM alpine

RUN apk add --no-cache openssh

RUN mkdir /container
COPY client-init.sh /container/
RUN chmod +x /container/client-init.sh
COPY server-init.sh /container/
RUN chmod +x /container/server-init.sh

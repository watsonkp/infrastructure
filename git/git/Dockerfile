FROM alpine

RUN apk add --no-cache git git-daemon

RUN adduser git --disabled-password --shell /usr/bin/git-shell

USER git

EXPOSE 9418/tcp

ENTRYPOINT ["/usr/bin/git"]
CMD ["daemon", "--reuseaddr", "--base-path=/srv/git/", "/srv/git"]

FROM docker.elastic.co/elasticsearch/elasticsearch:8.8.1

USER root

RUN mkdir /container
COPY tls-init.sh /container/tls-init.sh
RUN chmod +x /container/tls-init.sh

RUN chown -R elasticsearch:elasticsearch /container
USER elasticsearch

ENTRYPOINT ["/container/tls-init.sh"]

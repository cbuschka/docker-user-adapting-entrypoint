FROM debian:stretch

ENV HOME /worker

WORKDIR /work

COPY assets/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

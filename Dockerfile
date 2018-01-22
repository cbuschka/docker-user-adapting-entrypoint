FROM debian:stretch

ENV WORKER_NAME worker
ENV WORKER_UID 1000
ENV WORKER_GID 1000
ENV WORKER_HOME /home/worker

WORKDIR /work

COPY assets/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

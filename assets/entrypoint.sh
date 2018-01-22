#!/bin/bash

#
# This is the user adapting entry point for docker.
# Original [repository](https://github.com/cbuschka/docker-user-adapting-entrypoint) at github.
#

DEFAULT_WORKER_UID=1000
DEFAULT_WORKER_GID=1000
DEFAULT_WORKER_NAME=worker

if [ "x$UID" == "x0" ]; then
  if [ -z "${WORKER_NAME}" ]; then
    WORKER_NAME=${DEFAULT_WORKER_NAME}
  fi
  if [ -z "${WORKER_HOME}" ]; then
    WORKER_HOME=/home/${WORKER_NAME}
  fi
  if [ -z "${WORKER_UID}" ]; then
    WORKER_UID=${DEFAULT_WORKER_UID}
  fi
  if [ -z "${WORKER_GID}" ]; then
    WORKER_GID=${DEFAULT_WORKER_GID}
  fi

  groupadd -g ${WORKER_GID} ${WORKER_NAME}
  useradd -u ${WORKER_UID} -g ${WORKER_GID} -m -d ${WORKER_HOME} ${WORKER_NAME}

  WORK_DIR=${PWD}
  chown ${WORKER_NAME}.${WORKER_NAME} ${WORK_DIR}

  if [ -S "/var/run/docker.sock" ]; then
    DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)
    groupadd -g ${DOCKER_GID} docker
    usermod -G docker ${WORKER_NAME}
  fi
else
  echo "Should be run as root. Container will drop privileges on its own."
fi

CMD="$@"

exec su - ${WORKER_NAME} -c "cd ${WORK_DIR} && exec ${CMD}"

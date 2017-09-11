#!/bin/bash

DEFAULT_WORK_USER_UID=1000
DEFAULT_WORK_USER_GID=1000

if [ -z "${WORK_USER_UID}" ]; then
  WORK_USER_UID=${DEFAULT_WORK_USER_UID}
fi
if [ -z "${WORK_USER_GID}" ]; then
  WORK_USER_GID=${DEFAULT_WORK_USER_GID}
fi

groupadd -g ${WORK_USER_GID} worker
useradd -u ${WORK_USER_UID} -g ${WORK_USER_GID} -d /worker worker
chown -R worker.worker /worker

if [ -S "/var/run/docker.sock" ]; then
  DOCKER_GROUP_GID=$(stat -c '%g' /var/run/docker.sock)
  groupadd -g $DOCKER_GROUP_GID docker
  usermod -G docker worker
fi

WORK_DIR=$PWD

CMD="$@"

exec su - worker -c "cd $WORK_DIR && exec $CMD"

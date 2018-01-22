#!/bin/bash

docker run \
	-v $PWD:/work \
	-e WORKER_UID=1001 \
	-e WORKER_GID=1001 \
	-e WORKER_NAME=wrkr \
	-e WORKER_HOME=/home/sweethome \
	docker-user-adapting-entrypoint:local \
	/work/verify.sh

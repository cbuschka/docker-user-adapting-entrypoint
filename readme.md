# User adapting Entrypoint for Docker

Original [repository](https://github.com/cbuschka/docker-user-adapting-entrypoint) at github.

## What does it solve?

### Problem
* run container with current host user uid/gid ("worker user")
* how provide home directory when uid/gid of worker user not known at build time
* how to grant access to docker.socket to worker user

### Solution
 - run container and entrypoint as root
 - create user/group entry for worker user on startup
 - add user to docker group when docker.sock provided
 - execute command as worker user

## Build
```
docker build --tag docker-user-adapting-entrypoint:local .
```

## Run
```
docker run -ri --rm -v /var/run/docker.sock \
	-e WORKER_USER_UID=$(id -u) -e WORKER_USER_GID=$(id -g) \
	-v volume-in-work-dir:/work \
	-v some-subdir-in-home:/worker/subdir \
	docker-user-adapting-entrypoint:local bash
```

## Run (with docker access from within container)
```
docker run -ri --rm -v /var/run/docker.sock \
	-e WORKER_USER_UID=$(id -u) -e WORKER_USER_GID=$(id -g) \
	-v volume-in-work-dir:/work \
	-v some-subdir-in-home:/worker/subdir \
	-v /var/run/docker.sock:/var/run/docker.sock \
	docker-user-adapting-entrypoint:local bash
```


## License
Written by [Cornelius Buschka](https://github.com/cbuschka).

[MIT License](license)

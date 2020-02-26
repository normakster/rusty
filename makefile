LOCAL_PATH= #empty

ifeq ($(OS),Windows_NT)
		detected_OS := Windows
else
    detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
endif
ifeq ($(detected_OS),Windows)
    LOCAL_PATH := $(shell pwd)
endif
ifeq ($(detected_OS),Darwin)        # Mac OS X
    LOCAL_PATH := $(shell pwd)
endif
ifeq ($(detected_OS),Linux)
    LOCAL_PATH := $(shell pwd)
endif
ifeq ($(detected_OS),GNU)           # Debian GNU Hurd
    LOCAL_PATH := $(shell pwd)
endif

echo:
	@echo $(OS) : $(shell uname) : $(LOCAL_PATH)
build:
	@docker build -t rusty:latest .
run:
	@docker run --name rusty -it \
		--network=rusty-net \
		-p 81:80 \
		--dns 8.8.8.8 \
		--privileged \
		--mount "type=bind,src=/$(LOCAL_PATH),dst=/$(LOCAL_PATH)" \
		-v //var/run/docker.sock:/var/run/docker.sock \
		rusty:latest
login:
	@docker start rusty && docker exec -it rusty bash
stop:
	@docker stop rusty
reset:
	@make stop
	@docker container rm rusty


	# --mount "type=bind,src=/$(LOCAL_PATH),dst=/rusty" \

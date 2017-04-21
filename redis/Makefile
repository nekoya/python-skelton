REDIS_DOCKER_IMAGE = redis:3.2-alpine
REDIS_CONTAINER_NAME = redis

.PHONY: help
.DEFAULT_GOAL: help

help:
	@echo "These are public command list (\`・ω・´)"
	@grep -E '^[a-zA-Z_%-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

run: # Start up Redis container independently
	docker run --name $(REDIS_CONTAINER_NAME) -d $(REDIS_DOCKER_IMAGE)

stop: # Stop Redis container
	docker stop $(REDIS_CONTAINER_NAME)

clean: stop # Delete Redis container
	docker rm $(REDIS_CONTAINER_NAME)

connect: # Connect to existant Redis container
	docker run --link $(REDIS_CONTAINER_NAME) -it --rm $(REDIS_DOCKER_IMAGE) redis-cli -h $(REDIS_CONTAINER_NAME)

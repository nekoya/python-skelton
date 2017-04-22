MYSQL_DOCKER_IMAGE = mysql:5.6
MYSQL_CONTAINER_NAME = mysqld
MYSQL_ROOT_PASSWORD = mysqlrootpassword
MYSQL_USER = user
MYSQL_PASSWORD = mysqlpassword
MYSQL_DATABASE = mydatabase

.PHONY: help
.DEFAULT_GOAL: help

help:
	@echo "These are public command list (\`・ω・´)"
	@grep -E '^[a-zA-Z_%-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

run: # Start up MySQL container independently
	docker run --name $(MYSQL_CONTAINER_NAME) \
	-v $(CURDIR)/conf.d:/etc/mysql/conf.d \
	-v $(CURDIR)/sql:/docker-entrypoint-initdb.d \
	-e MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) \
	-e MYSQL_USER=$(MYSQL_USER) \
	-e MYSQL_PASSWORD=$(MYSQL_PASSWORD) \
	-e MYSQL_DATABASE=$(MYSQL_DATABASE) \
	-d $(MYSQL_DOCKER_IMAGE)

stop: # Stop MySQL container
	docker stop $(MYSQL_CONTAINER_NAME)

clean: stop # Delete MySQL container
	docker rm $(MYSQL_CONTAINER_NAME)

connect: # Connect to existant MySQL container
	docker run --link $(MYSQL_CONTAINER_NAME) \
	-v $(CURDIR)/mysql/conf.d:/etc/mysql/conf.d \
	-it --rm $(MYSQL_DOCKER_IMAGE) \
	sh -c "mysql -h $(MYSQL_CONTAINER_NAME) -u $(MYSQL_USER) -p$(MYSQL_PASSWORD) $(MYSQL_DATABASE)"

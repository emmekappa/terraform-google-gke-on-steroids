all: init fmt validate
.PHONY: lint

init:
	terraform init -backend=false

fmt:
	terraform fmt -recursive


validate:
	GITLAB_TOKEN="fake" terraform validate

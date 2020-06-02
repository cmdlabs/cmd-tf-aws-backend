RELEASE_VERSION = 0.8.0

ifdef CI
	PROFILE_REQUIRED=profile
endif

docs: .env
	docker-compose run --rm terraform-utils terraform-docs markdown document . --header-from s3.tf > README.md
PHONY: docs

format: .env
	docker-compose run --rm terraform-utils terraform fmt -recursive .
PHONY: format

formatCheck: .env
	docker-compose run --rm terraform-utils terraform fmt -recursive -check -diff .
PHONY: formatCheck

init: .env $(PROFILE_REQUIRED)
	docker-compose run --rm terraform-utils terraform init tests
PHONY: init

plan: .env $(PROFILE_REQUIRED) init
	docker-compose run --rm terraform-utils terraform plan tests
PHONY: plan

apply: .env $(PROFILE_REQUIRED) init
	docker-compose run --rm terraform-utils terraform apply -auto-approve tests
PHONY: apply

destroy: .env $(PROFILE_REQUIRED) init
	docker-compose run --rm terraform-utils terraform destroy -auto-approve tests
PHONY: destroy

tag:
	git tag -a $(RELEASE_VERSION) -m ''
	git push origin $(RELEASE_VERSION)
PHONY: tag

publish: .env
	docker-compose run --rm envvars ensure --tags publish
	git fetch --all
	git remote add github https://$(GIT_USERNAME):$(GIT_PASSWORD)@github.com/cmdlabs/$(CI_PROJECT_NAME)
	git checkout master
	git pull origin master
	git push --follow-tags github master
	docker-compose run --rm terraform-utils curl -X POST -H 'Content-type: application/json' --data '{"text":"A new commit has been published to Github\nProject: $(CI_PROJECT_NAME)\nRef: $(CI_COMMIT_REF_NAME)\nDiff: https://github.com/cmdlabs/$(CI_PROJECT_NAME)/commit/$(CI_COMMIT_SHA)"}' $(GIT_PUBLISHING_WEBHOOK)
PHONY: publish

profile: .env
	docker-compose run --rm envvars ensure --tags profile
	docker-compose run --rm aws sh -c 'aws configure set credential_source Ec2InstanceMetadata --profile $${AWS_PROFILE_NAME}'
	docker-compose run --rm aws sh -c 'aws configure set role_arn arn:aws:iam::$${AWS_ACCOUNT_ID}:role/$${AWS_ROLE_NAME} --profile $${AWS_PROFILE_NAME}'
	docker-compose run --rm aws aws configure set credential_source Ec2InstanceMetadata --profile cmdlabtf-tfbackend
	docker-compose run --rm aws aws configure set role_arn arn:aws:iam::471871437096:role/gitlab_runner --profile cmdlabtf-tfbackend

.env:
	touch .env
	docker-compose run --rm envvars validate
	docker-compose run --rm envvars envfile --overwrite


release-all: release-2.2 release-2.3 release-2.4 release-2.5 release-2.6

build:
	docker build \
		-t lowess/drone-molecule:experimental .

release-experimental:
	docker build \
		-t lowess/drone-molecule:experimental \
		--build-arg	ANSIBLE_PIP_VERSION=$(ANSIBLE_VERSION) \
		.
	docker push lowess/drone-molecule:experimental

release-7.1:
	$(eval ANSIBLE_VERSION := 7.1.0)
	docker build \
		-t lowess/drone-molecule:$(ANSIBLE_VERSION) \
		--build-arg	ANSIBLE_PIP_VERSION=$(ANSIBLE_VERSION) \
		.
	docker push lowess/drone-molecule:$(ANSIBLE_VERSION)


release-all: release-2.2 release-2.3 release-2.4 release-2.5 release-2.6

release-2.2:
	$(eval ANSIBLE_VERSION := 2.2.3.0)
	docker build \
		-t lowess/drone-molecule:$(ANSIBLE_VERSION) \
		--build-arg	ANSIBLE_PIP_VERSION=$(ANSIBLE_VERSION) \
		.
	docker push lowess/drone-molecule:$(ANSIBLE_VERSION)

release-2.3:
	$(eval ANSIBLE_VERSION := 2.3.3.0)
	docker build \
		-t lowess/drone-molecule:$(ANSIBLE_VERSION) \
		--build-arg	ANSIBLE_PIP_VERSION=$(ANSIBLE_VERSION) \
		.
	docker push lowess/drone-molecule:$(ANSIBLE_VERSION)

release-2.4:
	$(eval ANSIBLE_VERSION := 2.4.6.0)
	docker build \
		-t lowess/drone-molecule:$(ANSIBLE_VERSION) \
		--build-arg	ANSIBLE_PIP_VERSION=$(ANSIBLE_VERSION) \
		.
	docker push lowess/drone-molecule:$(ANSIBLE_VERSION)

release-2.5:
	$(eval ANSIBLE_VERSION := 2.5.8)
	docker build \
		-t lowess/drone-molecule:$(ANSIBLE_VERSION) \
		--build-arg	ANSIBLE_PIP_VERSION=$(ANSIBLE_VERSION) \
		.
	docker push lowess/drone-molecule:$(ANSIBLE_VERSION)

release-2.6:
	$(eval ANSIBLE_VERSION := 2.6.3)
	docker build \
		-t lowess/drone-molecule:$(ANSIBLE_VERSION) \
		--build-arg	ANSIBLE_PIP_VERSION=$(ANSIBLE_VERSION) \
		.
	docker push lowess/drone-molecule:$(ANSIBLE_VERSION)

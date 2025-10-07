.PHONY: dev-release

dev-release:
	bosh create-release --force --tarball=victorialogs-boshrelease.tgz

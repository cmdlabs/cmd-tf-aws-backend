VERSION = 0.1

PHONY: tag
tag:
	git tag $(VERSION)
	git push origin $(VERSION)

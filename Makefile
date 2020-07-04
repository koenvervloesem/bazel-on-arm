.PHONY: bazel check clean dev_requirements install requirements uninstall

bazel:
	./scripts/build_bazel.sh

check:
	./scripts/check_code.sh

clean:
	rm -r bazel

dev_requirements:
	./scripts/install_dev_requirements.sh

install:
	cp bazel/output/bazel /usr/local/bin/

requirements:
	./scripts/install_requirements.sh

uninstall:
	rm /usr/local/bin/bazel

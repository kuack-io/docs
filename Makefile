.PHONY: install upgrade lint lint-fix format check package

install:
	npm install

upgrade:
	npm update

lint:
	npm run lint

lint-fix:
	npm run lint -- --fix

format:
	npm run format

check: lint format

package:
	./scripts/package-assets.sh 0.0.0-test

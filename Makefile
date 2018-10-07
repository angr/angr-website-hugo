SHELL:=$(shell which bash)
VIRTUALENV_NAME:=.venv

.PHONY: local
default: local

public:
	git clone git@github.com:angr/angr.github.io.git public

.PHONY: install
install: $(VIRTUALENV_NAME)

.ONESHELL:
$(VIRTUALENV_NAME):
	python3 -m venv $(VIRTUALENV_NAME)
	source $(VIRTUALENV_NAME)/bin/activate
	pip install --upgrade pip
	pip install -r requirements.txt

.PHONY: uninstall
uninstall:
	rm -rf $(VIRTUALENV_NAME)

.PHONY: check
.ONESHELL:
check: install
	@if [[ -z "${ANGR_ROOT}" ]]; then echo "Set ANGR_ROOT to the path to your angr-dev directory"; exit 1; fi
	. $(VIRTUALENV_NAME)/bin/activate
	python code-finder.py ${ANGR_ROOT} content/blog/*

.PHONY: build
build: check public
	hugo

.PHONY: deploy
.ONESHELL:
deploy: build
	cd public
	git add .
	git commit -m "Rebuilding hugo site"
	git push

.PHONY: local
local:
	hugo server

.PHONY: clean
clean:
	rm -rf public

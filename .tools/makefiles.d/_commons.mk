MAKEFLAGS += --no-print-directory
.DEFAULT_GOAL := help

.POSIX:
.PHONY: *

help: ## This help
	@find . -name Makefile -o -name "*.mk" | xargs -n1 grep -hE '^[a-z0-9\-]+:.* ##' | sed 's/\: .*##/:/g' | sort | column  -ts':'

doc-generate: ## Generate main Readme commands list
	@make > /tmp/doc-generate.txt
	@bash -c 'export COMMANDS="$$(cat /tmp/doc-generate.txt)" ; envsubst < README.tpl > README.md'
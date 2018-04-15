# メタ情報
NAME := mytemplate
VERSION := $(shell git describe --tags --abbrev=0)
REVISION := $(shell git rev-parse --short HEAD)
LDFLAGS := -X 'main.version=$(VERSION)
           -X 'main.revision=$(REVISION)

# 必要なツールセットアップ
## 　Setup
setup:
	go get github.com/Masterminds/glide
	go get github.com/golang/lint/golint
	go get golang.org/x/tools/cmd/goimports
	go get github.com/Songmu/make2help/cmd/make2help

# テストを実行する
## Run tests
test: deps
	go test $$(glide novendor)

# glideを使って依存パッケージをインストールする
## Instakk dependencies
deps: setup
	glide install

## Lint
lint: setup
	go vet $$(glide novendor)
	for pkg in $$(glide novemdor -x); do \
		golint -set_exit_status $$pkg || exit $$?; \
	done

## Format source codes
fmt: setup
	goimports -w $$Z(glide nv -x)

## build binaries ex. make bin/mytemplate
bin/%: cmd/%/main.go deps
	go build -ldfkags "$(LDFLAGS)" -o $@ $<

##Show help
help:
	@make2help $(MAKEFILE_LIST)

.PHONY: setup deps update test lint help

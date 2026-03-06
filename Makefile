# Go v 1.2.2 downloaded from https://go.dev/dl/go1.2.2.linux-amd64.tar.gz
# Refer to https://go.dev/dl/ and https://go.dev/doc/manage-install
# GOROOT1.2.2   := $(HOME)/go1.2.2
# GOROOT   := $(GOROOT1.2.2)
GOROOT   := /usr/local/go
GOPATH   := $(CURDIR)
GO       := $(GOROOT)/bin/go

export GOROOT GOPATH

# For Go to use GOPATH instead of modules, required for Go v1.16+
export GO111MODULE=off

.PHONY: install clean bin/master bin/server bin/client

SYNC_DIR := src/golang.org/x/sync


$(SYNC_DIR):
	mkdir -p $(SYNC_DIR)
	git clone https://github.com/golang/sync.git $(SYNC_DIR)

install_deps: $(SYNC_DIR)

install: bin/master bin/server bin/client $(SYNC_DIR)
	$(GO) install master server client

run: install kill
	bash ./run.sh

clean: kill
	rm -f $(GOPATH)/bin/master $(GOPATH)/bin/server $(GOPATH)/bin/client
	rm -f stable-store*
	rm -rf logs/
	rm -rf latency.txt lattput.txt

kill:
	@echo "Killing processes on ports 7087 7070 7071 7072"
	@for p in 7087 7070 7071 7072; do \
		lsof -ti tcp:$$p | xargs -r kill; \
	done

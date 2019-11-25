# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: g3th android ios g3th-cross swarm evm all test clean
.PHONY: g3th-linux g3th-linux-386 g3th-linux-amd64 g3th-linux-mips64 g3th-linux-mips64le
.PHONY: g3th-linux-arm g3th-linux-arm-5 g3th-linux-arm-6 g3th-linux-arm-7 g3th-linux-arm64
.PHONY: g3th-darwin g3th-darwin-386 g3th-darwin-amd64
.PHONY: g3th-windows g3th-windows-386 g3th-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

g3th:
	build/env.sh go run build/ci.go install ./cmd/g3th
	@echo "Done building."
	@echo "Run \"$(GOBIN)/g3th\" to launch g3th."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/g3th.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/G3TH.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/jteeuwen/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go install ./cmd/abigen

# Cross Compilation Targets (xgo)

g3th-cross: g3th-linux g3th-darwin g3th-windows g3th-android g3th-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/g3th-*

g3th-linux: g3th-linux-386 g3th-linux-amd64 g3th-linux-arm g3th-linux-mips64 g3th-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/g3th-linux-*

g3th-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/g3th
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/g3th-linux-* | grep 386

g3th-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/g3th
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/g3th-linux-* | grep amd64

g3th-linux-arm: g3th-linux-arm-5 g3th-linux-arm-6 g3th-linux-arm-7 g3th-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/g3th-linux-* | grep arm

g3th-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/g3th
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/g3th-linux-* | grep arm-5

g3th-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/g3th
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/g3th-linux-* | grep arm-6

g3th-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/g3th
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/g3th-linux-* | grep arm-7

g3th-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/g3th
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/g3th-linux-* | grep arm64

g3th-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/g3th
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/g3th-linux-* | grep mips

g3th-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/g3th
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/g3th-linux-* | grep mipsle

g3th-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/g3th
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/g3th-linux-* | grep mips64

g3th-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/g3th
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/g3th-linux-* | grep mips64le

g3th-darwin: g3th-darwin-386 g3th-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/g3th-darwin-*

g3th-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/g3th
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/g3th-darwin-* | grep 386

g3th-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/g3th
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/g3th-darwin-* | grep amd64

g3th-windows: g3th-windows-386 g3th-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/g3th-windows-*

g3th-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/g3th
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/g3th-windows-* | grep 386

g3th-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/g3th
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/g3th-windows-* | grep amd64

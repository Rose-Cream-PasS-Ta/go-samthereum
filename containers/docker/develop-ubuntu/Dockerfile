FROM ubuntu:xenial

RUN \
  apt-get update && apt-get upgrade -q -y && \
  apt-get install -y --no-install-recommends golang git make gcc libc-dev ca-certificates && \
  git clone --depth 1 https://github.com/musicoin/go-musicoin && \
  (cd go-ethereum && make g3th) && \
  cp go-ethereum/build/bin/g3th /g3th && \
  apt-get remove -y golang git make gcc libc-dev && apt autoremove -y && apt-get clean && \
  rm -rf /go-ethereum

EXPOSE 8545
EXPOSE 30303

ENTRYPOINT ["/g3th"]

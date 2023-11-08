# syntax=docker/dockerfile:1

FROM docker:cli

RUN apk add --no-cache clang musl-dev git curl jq bash

WORKDIR /app

COPY . .

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install --force cargo-make

RUN git clone https://github.com/consensus-shipyard/fendermint.git && \
  cd fendermint && \
  cargo make --makefile ./infra/Makefile.toml info

ENTRYPOINT ["/bin/bash", "-c"]
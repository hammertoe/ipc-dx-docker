# syntax=docker/dockerfile:1

# Use a multi-stage build to compile the application
FROM rust:alpine as builder

WORKDIR /usr/src/fendermint
# Install dependencies required for the build
RUN apk add --no-cache clang musl-dev git curl jq bash \
    && git clone https://github.com/consensus-shipyard/fendermint.git . \
    && cargo install --force cargo-make


# Start with a new, clean base image to reduce size
FROM docker:cli

# Install runtime dependancies
RUN apk add --no-cache bash jq curl libgcc

# Copy only the compiled binaries and any other necessary files from the builder image
COPY --from=builder /usr/local/cargo/bin /usr/local/cargo/bin
COPY --from=builder /usr/src/fendermint /app/fendermint
COPY ./fendermint.sh /app

# Set any environment variables needed
ENV PATH="/usr/local/cargo/bin:${PATH}"

# Pre-populate the rust cargo cache
RUN /app/fendermint.sh info

# Set the entrypoint
ENTRYPOINT /app/fendermint.sh

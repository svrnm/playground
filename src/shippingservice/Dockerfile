# build context will only work from ../../docker-compose.yml
FROM --platform=$BUILDPLATFORM rust:1.61-alpine as builder

ARG TARGETOS TARGETARCH TARGETPLATFORM BUILDPLATFORM

RUN apk update
RUN apk add --no-cache ca-certificates git protobuf-dev protoc cmake clang clang-dev make gcc g++ libc-dev linux-headers

RUN echo $TARGETPLATFORM $BUILDPLATFORM
RUN if [ "$TARGETPLATFORM" != "$BUILDPLATFORM" ]; then apk add gcc-aarch64-none-elf && rustup target add aarch64-unknown-linux-musl && rustup toolchain install stable-aarch64-unknown-linux-musl; fi

WORKDIR /app/

# build app
COPY /src/shippingservice/ /app/
COPY /pb/ /app/proto/

RUN if [ "$TARGETPLATFORM" = "$BUILDPLATFORM" ]; \
        then cargo build -r --features="dockerproto"; \
    else \  
        env CARGO_TARGET_AARCH64_UNKNOWN_LINUX_MUSL_LINKER=aarch64-none-elf-gcc \
            cargo build -r --features="dockerproto" --target aarch64-unknown-linux-musl && \  
            cp /app/target/aarch64-unknown-linux/musl/release/shippingservice /app/target/release/shippingservice; \
    fi

FROM alpine as release
RUN apk add --no-cache ca-certificates
RUN GRPC_HEALTH_PROBE_VERSION=v0.4.7 && \
    wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe
WORKDIR /app
# /app/app/target/aarch64-unknown-linux-musl/release
COPY --from=builder /app/target/release/shippingservice /app/shippingservice

EXPOSE ${SHIPPING_SERVICE_PORT}
ENTRYPOINT ["/app/shippingservice"]

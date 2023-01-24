# build context will only work from ../../docker-compose.yml
FROM --platform=linux/amd64 rust:1.61 as builder

ARG TARGETOS TARGETARCH TARGETPLATFORM BUILDPLATFORM

RUN apt update && apt upgrade -y 
RUN apt install -y g++-aarch64-linux-gnu libc6-dev-arm64-cross libprotobuf-dev protobuf-compiler

RUN rustup target add aarch64-unknown-linux-gnu 
RUN rustup toolchain install stable-aarch64-unknown-linux-gnu

WORKDIR /app/

# build app
COPY /src/shippingservice/ /app/
COPY /pb/ /app/proto/

ENV CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-linux-gnu-gcc 
ENV CC_aarch64_unknown_linux_gnu=aarch64-linux-gnu-gcc 
ENV CXX_aarch64_unknown_linux_gnu=aarch64-linux-gnu-g++

RUN cargo build -r --features="dockerproto" --target aarch64-unknown-linux-gnu
RUN cp /app/target/aarch64-unknown-linux-gnu/release/shippingservice /app/target/release/shippingservice;

FROM busybox:glibc as release
#RUN apk add --no-cache ca-certificates
#RUN GRPC_HEALTH_PROBE_VERSION=v0.4.7 && \
#    wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
#    chmod +x /bin/grpc_health_probe
WORKDIR /app
# /app/app/target/aarch64-unknown-linux-musl/release
COPY --from=builder /app/target/release/shippingservice /app/shippingservice

EXPOSE ${SHIPPING_SERVICE_PORT}
# ENTRYPOINT ["/app/shippingservice"]
ENTRYPOINT [ "/bin/sh" ]

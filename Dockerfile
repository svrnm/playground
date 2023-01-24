# build context will only work from ../../docker-compose.yml
FROM rust:1.61-alpine as builder

WORKDIR /app/

# build app
COPY /src/shippingservice/ /app/
COPY /pb/ /app/proto/

ENTRYPOINT [ "/bin/sh" ]

# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM --platform=$BUILDPLATFORM golang:1.19.2-alpine AS grpc-builder
RUN apk add build-base protobuf-dev protoc
WORKDIR /usr/src/app/

COPY ./pb/ ./proto/

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
RUN protoc -I ./proto/ ./proto/demo.proto --go_out=./ --go-grpc_out=./

FROM --platform=$BUILDPLATFORM golang:1.19.2-alpine AS builder
# FROM golang:1.19.2-alpine AS builder
# RUN apk add build-base protobuf-dev protoc
WORKDIR /usr/src/app/

ARG TARGETOS TARGETARCH

# Restore dependencies
COPY ./src/checkoutservice/ ./

# Build executable
ARG GOOS=${TARGETOS} GOARCH=${TARGETARCH}
RUN echo $GOOS $GOARCH
RUN go mod download

COPY --from=grpc-builder /usr/src/app/ ./

RUN go build -o /go/bin/checkoutservice/ ./

# -----------------------------------------------------------------------------

FROM alpine

WORKDIR /usr/src/app/

COPY --from=builder /go/bin/checkoutservice/ ./

EXPOSE ${CHECKOUT_SERVICE_PORT}
ENTRYPOINT [ "./checkoutservice" ]

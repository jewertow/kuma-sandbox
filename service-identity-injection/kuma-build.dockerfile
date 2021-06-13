FROM golang:1.16-alpine3.12

RUN apk add make curl bash openssl git

COPY kuma/ /opt/

WORKDIR /opt
RUN make dev/tools
RUN make build

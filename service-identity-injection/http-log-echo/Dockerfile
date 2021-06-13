FROM alpine:latest

RUN apk add curl

COPY ./http-log-echo-server /opt/http-log-echo-server

ENTRYPOINT ["/opt/http-log-echo-server"]

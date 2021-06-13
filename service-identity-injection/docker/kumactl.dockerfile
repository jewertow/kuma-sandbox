FROM alpine:3.13.3

RUN apk add --no-cache curl

ADD bin/kumactl/kumactl /usr/bin

RUN mkdir /kuma

RUN addgroup -S -g 6789 kumactl \
 && adduser -S -D -G kumactl -u 6789 kumactl

USER kumactl
WORKDIR /home/kumactl

CMD ["/bin/sh"]

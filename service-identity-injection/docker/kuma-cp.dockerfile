FROM alpine:3.13.3

ADD bin/kuma-cp/kuma-cp /usr/bin

RUN mkdir -p /etc/kuma
ADD config/kuma-cp/kuma-cp.defaults.yaml /etc/kuma

RUN mkdir /kuma

USER nobody:nobody

ENTRYPOINT ["kuma-cp"]

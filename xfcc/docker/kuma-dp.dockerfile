FROM envoyproxy/envoy-alpine:v1.17.1

ADD bin/kuma-dp/kuma-dp /usr/bin
ADD bin/coredns/coredns /usr/bin

RUN mkdir /kuma

USER nobody:nobody

ENTRYPOINT ["kuma-dp"]

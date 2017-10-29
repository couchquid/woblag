from golang:1.9.2-alpine3.6 as build

ARG CADDY_VERSION="0.10.10"
ARG PLUGINS="git"

RUN apk add --no-cache git

RUN git clone https://github.com/mholt/caddy -b "v${CADDY_VERSION}" /go/src/github.com/mholt/caddy \
    && cd /go/src/github.com/mholt/caddy \
    && git checkout -b "v${CADDY_VERSION}"

RUN go get -v github.com/abiosoft/caddyplug/caddyplug

RUN for plugin in $(echo $PLUGINS | tr "," " "); do \
    go get -v $(caddyplug package $plugin); \
    printf "package caddyhttp\nimport _ \"$(caddyplug package $plugin)\"" > \
        /go/src/github.com/mholt/caddy/caddyhttp/$plugin.go ; \
    done

RUN git clone https://github.com/caddyserver/builds /go/src/github.com/caddyserver/builds

RUN cd /go/src/github.com/mholt/caddy/caddy \
    && git checkout -f \
    && go run build.go \
    && mv caddy /go/bin

from alpine:3.6
MAINTAINER Alexander Nordahl <alex@aqumbo.se>

ENV HUGO_VERSION=0.30.2

COPY --from=build /go/bin/caddy /usr/bin/caddy

RUN apk add --no-cache ca-certificates git

COPY Caddyfile /etc/Caddyfile

ENV CADDYPATH=/etc/.caddy
VOLUME /etc/.caddy

ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz /tmp
RUN tar -xf /tmp/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz -C /tmp \
    && mv /tmp/hugo /usr/bin/hugo

RUN mkdir -p /www/public/log

WORKDIR /www

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout"]

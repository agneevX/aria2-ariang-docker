FROM alpine:3.12

ARG ARIANG_VERSION
ARG BUILD_DATE
ARG VCS_REF

ENV DOMAIN=0.0.0.0:8080
ENV ARIA2RPCPORT=8080

LABEL maintainer="hurlenko" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="aria2-ariang" \
    org.label-schema.description="Aria2 downloader and AriaNg webui Docker image based on Alpine Linux" \
    org.label-schema.version=$ARIANG_VERSION \
    org.label-schema.url="https://github.com/hurlenko/aria2-ariang-docker" \
    org.label-schema.license="MIT" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/hurlenko/aria2-ariang-docker" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vendor="hurlenko" \
    org.label-schema.schema-version="1.0"

RUN apk update \
    && apk add --no-cache --update caddy aria2 su-exec

# AriaNG
RUN mkdir /usr/local/www/ariang \
    && cd usr/local/www/ariang \
    && wget --no-check-certificate https://github.com/mayswind/AriaNg/releases/download/${ARIANG_VERSION}/AriaNg-${ARIANG_VERSION}.zip \
    -O ariang.zip \
    && unzip ariang.zip \
    && rm ariang.zip \
    && chmod -R 755 ./

COPY aria2.conf /docker-aria2.conf
COPY start.sh /app/
COPY Caddyfile /usr/local/caddy/

VOLUME /downloads
VOLUME /config

WORKDIR /config

EXPOSE 8080

ENTRYPOINT ["/bin/sh"]

CMD ["/app/start.sh"]

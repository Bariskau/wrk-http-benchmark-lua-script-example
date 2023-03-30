FROM alpine:latest as build
RUN apk add --update alpine-sdk perl bash
RUN cd /tmp                               && \
    git clone -b 4.0.2 https://github.com/wg/wrk
RUN cd /tmp/wrk                           && \
    make

FROM alpine:latest

COPY --from=build /tmp/wrk/wrk /usr/local/bin/
COPY . /data/

RUN apk add --no-cache libgcc bash
WORKDIR /data

COPY entrypoint.sh /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.d/entrypoint.sh"]

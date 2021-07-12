FROM registry:2.6
LABEL maintainer="registry-proxy Docker Maintainers https://fuckcloudnative.io"
ENV PROXY_REMOTE_URL="" \
    DELETE_ENABLED=""
COPY entrypoint.sh /entrypoint.sh

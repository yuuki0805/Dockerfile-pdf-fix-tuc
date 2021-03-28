FROM alpine:3.12 as builder
RUN apk update && \
    apk add qpdf-dev git g++ autoconf automake gawk make python3 && \
    mkdir /build && \
    cd /build && \
    git clone https://github.com/trueroad/pdf-fix-tuc.git && \
    cd pdf-fix-tuc && \
    ./autogen.sh && \
    mkdir ./build && \
    cd ./build && \
    ../configure && \
    make && \
    make install

FROM alpine:latest as runner
RUN apk update && \
    apk add --no-cache qpdf-dev && \
    mkdir /data
COPY --from=builder /usr/local/bin/pdf-fix-tuc /usr/local/bin/pdf-fix-tuc
COPY docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
VOLUME ["/data"]
ENTRYPOINT ["docker-entrypoint.sh"]

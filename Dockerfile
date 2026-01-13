FROM alpine:latest

LABEL maintainer="Thien Tran contact@tommytran.io"

RUN apk -U upgrade \
    && apk add libstdc++ rspamd \
    && rm -rf /var/cache/apk/*

ADD https://github.com/rspamd/rspamd-docker/raw/refs/heads/main/lid.176.ftz /usr/share/rspamd/languages/fasttext_model.ftz

COPY --from=ghcr.io/polarix-containers/hardened_malloc:latest /install /usr/local/lib/
ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"

USER	11333:11333

VOLUME  [ "/var/lib/rspamd" ]
# https://www.rspamd.com/doc/workers
# 11332 proxy ; 11333 normal ; 11334 controller
EXPOSE  11332 11333 11334

CMD     [ "/usr/bin/rspamd", "-f" ]
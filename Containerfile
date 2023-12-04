FROM alpine:3

RUN apk add --no-cache avahi envsubst samba

RUN rm /etc/avahi/services/* /etc/samba/smb.conf

COPY avahi-daemon.conf /etc/avahi
COPY timemachine.service /etc/avahi/services
COPY smb.conf.template /etc/samba
COPY timemachine /usr/bin

LABEL org.label-schema.vcs-url="https://github.com/jmanero/container-image-timemachine"

ENV CONF_FILE="/run/samba/smb.conf"

ENV STATE_DIR="/var/lib/samba"
ENV CACHE_DIR="${STATE_DIR}/cache"
ENV PRIVATE_DIR="${STATE_DIR}/private"
ENV LOCK_DIR="/run/samba/locks"
ENV PID_DIR="/run"

ENV LOG_FILE="/dev/stdout"
ENV MAX_LOG_SIZE="16M"
ENV DEBUG_LEVEL="1"

ENV PASSDB_BACKEND="tdbsam"

ENV MAX_XATTR_SIZE="65536"
ENV TIMEMACHINE_PATH="/data/%U"
ENV TIMEMACHINE_MAX_SIZE="500G"

CMD [ "/usr/bin/timemachine" ]

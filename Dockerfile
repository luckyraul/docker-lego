FROM goacme/lego:v4.26

LABEL org.opencontainers.image.source=https://github.com/luckyraul/docker-lego

# Set Supercronic version and build-time architecture
ARG SUPERCRONIC_VERSION=v0.2.34
ARG TARGETARCH

RUN addgroup -g 1001 -S lego && adduser -u 1001 -S -G lego lego

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-${TARGETARCH} \
    SUPERCRONIC=supercronic-linux-${TARGETARCH}
RUN apk add --no-cache curl && \curl -fsSLO "$SUPERCRONIC_URL" \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic \
    && apk del curl

RUN mkdir -p /etc/lego /etc/cron.d && \
    chown -R lego:lego /etc/lego /etc/cron.d

ENV LEGO_PATH=/etc/lego

# Switch to non-root user
USER lego

# Set working directory
WORKDIR /home/lego

ENTRYPOINT []
EXPOSE 8080

VOLUME ["/etc/lego", "/etc/cron.d"]

CMD ["/usr/local/bin/supercronic", "/etc/cron.d/lego-cron"]
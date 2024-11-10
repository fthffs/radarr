# Build
FROM debian:12.7-slim as builder

ARG PROWLARR_VERSION=1.25.4.4818

RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  tar \
  tzdata ; \
  rm -rf /var/lib/apt/lists/* ;\
  mkdir -p /app/prowlarr; \
  curl -fsSL "https://github.com/Prowlarr/Prowlarr/releases/download/v${PROWLARR_VERSION}/prowlarr.master.${PROWLARR_VERSION}.linux-core-x64.tar.gz"  \
  | tar xzf - -C /app/prowlarr --strip-components=1; \
  rm -rf /app/prowlarr/Prowlarr.Update

FROM debian:12.7-slim
COPY --from=builder --chown=docker:docker /app/prowlarr /app

# Install binaries
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
  ca-certificates \
  libicu72 \
  sqlite3 \
  tzdata \
  curl \
  ; \
  rm -rf /var/lib/apt/lists/*

# Create user
RUN set -eux; \
  groupadd --gid 1000  docker; \
  useradd --uid 1000 docker --shell /sbin/nologin -g docker

EXPOSE 9696
USER docker	
VOLUME ["/config"]

CMD ["/app/Prowlarr", "-nobrowser", "-data=/config"]

HEALTHCHECK --start-period=10s --interval=30s --timeout=5s \
  CMD ["curl", "-fsS", "-m", "10", "--retry", "5", "-o", "/dev/null",  "http://127.0.0.1:9696/"]

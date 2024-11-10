# Build
FROM debian:12.7-slim as builder

ARG SONARR_VERSION=4.0.10.2544

RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  tar \
  tzdata ; \
  rm -rf /var/lib/apt/lists/* ;\
  mkdir -p /app/sonarr; \
  curl -fsSL "https://github.com/Sonarr/Sonarr/releases/download/v${SONARR_VERSION}/Sonarr.main.${SONARR_VERSION}.linux-x64.tar.gz"  \
  | tar xzf - -C /app/sonarr --strip-components=1; \
  rm -rf /app/sonarr/Sonarr.Update

FROM debian:12.7-slim
COPY --from=builder --chown=docker:docker /app/sonarr /app

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

EXPOSE 8989
USER docker
VOLUME ["/config"]

CMD ["/app/Sonarr", "-nobrowser", "-data=/config"]

HEALTHCHECK --start-period=10s --interval=30s --timeout=5s \
  CMD ["curl", "-fsS", "-m", "10", "--retry", "5", "-o", "/dev/null",  "http://127.0.0.1:8989/"]

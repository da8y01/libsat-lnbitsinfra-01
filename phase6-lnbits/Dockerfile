# FASE 6: LNbits (instalado desde fuente con UV, modulo_7)
# Multi-stage: el builder instala dependencias con `uv sync --all-extras`,
# el runtime hereda el .venv y arranca con `uv run lnbits`.
ARG LNBITS_VERSION=v1.5.6

FROM python:3.12-slim-bookworm AS builder

ARG LNBITS_VERSION=v1.5.6

RUN apt-get update && apt-get install -y --no-install-recommends \
        curl git ca-certificates pkg-config build-essential automake \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

# El venv se crea en /app del builder para que los shebangs de los scripts
# (p.ej. /app/.venv/bin/lnbits) coincidan con la ruta del runtime.
WORKDIR /app
RUN git clone --depth 1 --branch ${LNBITS_VERSION} https://github.com/lnbits/lnbits.git .

RUN uv sync --all-extras

FROM python:3.12-slim-bookworm

# curl es necesario para el healthcheck del compose
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

WORKDIR /app
COPY --from=builder /app /app

ENV LNBITS_PORT="5000"
ENV LNBITS_HOST="0.0.0.0"
ENV LNBITS_DATA_FOLDER="/app/data"

RUN mkdir -p /app/data

EXPOSE 5000

CMD ["sh", "-c", "uv --offline run --no-sync lnbits --port $LNBITS_PORT --host $LNBITS_HOST --forwarded-allow-ips='*'"]
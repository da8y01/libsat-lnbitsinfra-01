# ==== FASE 5: satoshi-odyssey (Dashboard web para LND) =======================
#
# Cliente web para gestión de LND (https://github.com/btcol/satoshi-odyssey).
# Se clona el repositorio original durante el build.
# A diferencia del Dockerfile original, esta imagen añade:
#   - jq: requerido por los scripts del dashboard.
#   - lncli v0.19.0-beta: el Dockerfile upstream no lo incluye; se descarga el
#     binario del release de LND y se envuelve en /usr/local/bin/lncli-remote
#     para que conecte al contenedor lnd (RPC 10009) con tls.cert y macaroons.

# ---- Etapa 1: Builder (clon + dependencias Python) --------------------------
FROM python:3.12-slim AS builder

WORKDIR /opt/src

RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/btcol/satoshi-odyssey.git

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r /opt/src/satoshi-odyssey/satoshi-odyssey/requirements.txt

# ---- Etapa 2: Imagen final de la aplicación ----------------------------------
FROM python:3.12-slim AS app

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    jq curl \
    && rm -rf /var/lib/apt/lists/*

# Copiar los paquetes Python instalados desde la etapa builder
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Código fuente de la aplicación (subdirectorio satoshi-odyssey del repo)
COPY --from=builder /opt/src/satoshi-odyssey/satoshi-odyssey /app

# Binario lncli (debe coincidir con la versión del servicio lnd)
RUN curl -fsSL -o /tmp/lnd.tar.gz \
        https://github.com/lightningnetwork/lnd/releases/download/v0.19.0-beta/lnd-linux-amd64-v0.19.0-beta.tar.gz \
    && tar -xzf /tmp/lnd.tar.gz -C /tmp \
    && install -m 0755 /tmp/lnd-linux-amd64-v0.19.0-beta/lncli /usr/local/bin/lncli-real \
    && rm -rf /tmp/lnd*

# Wrapper: elimina "-network=..." (lo fuerza el propio lncli) y apunta a lnd:10009
COPY lncli-remote /usr/local/bin/lncli-remote
RUN chmod 0755 /usr/local/bin/lncli-remote

# Directorios de datos persistentes.
# NOTA: la imagen se ejecuta como root porque debe poder leer el admin.macaroon
# y el tls.cert de LND (ficheros 0600 de root) desde el volumen lnd_data montado
# en solo lectura; así lo hace también la imagen oficial de RTL.
RUN mkdir -p data backups exports

EXPOSE 9630

ENV WEB_HOST=0.0.0.0 \
    WEB_PORT=9630 \
    WEB_USER=admin \
    WEB_PASS=lightning \
    NETWORK=testnet4 \
    LNCLI_BIN=/usr/local/bin/lncli-remote \
    LND_DIR=/data/lnd \
    LND_REST_HOST=https://lnd:8080 \
    LND_TLS_PATH=/data/lnd/tls.cert \
    LND_MACAROON_PATH=/data/lnd/data/chain/bitcoin/testnet4/admin.macaroon \
    PYTHONUNBUFFERED=1

CMD ["python3", "app.py"]
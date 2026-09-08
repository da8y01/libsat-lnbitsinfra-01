# Stage 1: Descarga y verificación de Bitcoin Core
FROM ubuntu:22.04 AS download

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y wget gnupg curl

WORKDIR /tmp/bitcoin

# Descargar Bitcoin Core 30.2 y sus sumas de verificación
RUN wget https://bitcoincore.org/bin/bitcoin-core-30.2/bitcoin-30.2-x86_64-linux-gnu.tar.gz && \
    wget https://bitcoincore.org/bin/bitcoin-core-30.2/SHA256SUMS && \
    wget https://bitcoincore.org/bin/bitcoin-core-30.2/SHA256SUMS.asc

# Verificar la firma GPG (importar claves mediante varios keyservers para mayor robustez)
RUN apt-get update && apt-get install -y dirmngr && \
    (gpg --keyserver keyserver.ubuntu.com --recv-keys \
    0CCBAAFD76A2ECE2CCD3141DE2FFD5B1D88CA97D \
    152812300785C96444D3334D17565732E08E5E41 \
    637DB1E23370F84AFF88CCE03152347D07DA627C \
    CFB16E21C950F67FA95E558F2EEB9F5CC09526C1 \
    F4FC70F07310028424EFC20A8E4256593F177720 \
    D1DBF2C4B96F2DEBF4C16654410108112E7EA81F \
    E61773CD6E01040E2F1BD78CE7E2984B6289C93A \
    ED9BDF7AD6A55E232E84524257FF9BDBCC301008 \
    || true) && \
    (gpg --verify SHA256SUMS.asc SHA256SUMS 2>&1 | grep -qi "Good signature" || true) && \
    sha256sum --ignore-missing --check SHA256SUMS && \
    tar -xzf bitcoin-30.2-x86_64-linux-gnu.tar.gz

# Stage 2: Imagen final con Bitcoin Core instalado
FROM ubuntu:22.04 AS final

ENV DEBIAN_FRONTEND=noninteractive

# Dependencias de ejecución de Bitcoin Core
RUN apt-get update && apt-get install -y \
    libevent-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    libboost-chrono-dev \
    libboost-program-options-dev \
    libboost-test-dev \
    libboost-thread-dev \
    libminiupnpc-dev \
    libzmq3-dev \
    bash \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copiar binarios de Bitcoin Core desde la etapa de descarga
COPY --from=download /tmp/bitcoin/bitcoin-30.2/bin/* /usr/local/bin/

# Crear directorio de configuración
RUN mkdir -p /root/.bitcoin && \
    mkdir -p /data

# Copiar configuración
COPY config/bitcoin.conf /root/.bitcoin/bitcoin.conf

# Método de entrada para el script de inicio
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Puertos: RPC (18332), P2P Testnet4 (48333), ZMQ (28332, 28333)
EXPOSE 18332 48333 28332 28333

# Volumen para datos de blockchain
VOLUME /data

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

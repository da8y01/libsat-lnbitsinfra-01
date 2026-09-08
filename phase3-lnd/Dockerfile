# Stage 1: Construcción de LND con Go
FROM golang:1.23.6 AS builder

ENV GOPATH=/go
ENV PATH=/usr/local/go/bin:/go/bin:$PATH

# Instalar herramientas de compilación
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    make \
    && rm -rf /var/lib/apt/lists/*

# Descargar código fuente de LND
WORKDIR $GOPATH/src/github.com/lightningnetwork
RUN git clone https://github.com/lightningnetwork/lnd.git lnd && \
    cd lnd && \
    git checkout v0.19.0-beta

# Compilar e instalar LND
WORKDIR $GOPATH/src/github.com/lightningnetwork/lnd
RUN make && make install

# Stage 2: Imagen final de ejecución
FROM ubuntu:22.04 AS final

ENV DEBIAN_FRONTEND=noninteractive

# Dependencias de ejecución
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Copiar binarios de LND compilados
COPY --from=builder /go/bin/lnd /usr/local/bin/lnd
COPY --from=builder /go/bin/lncli /usr/local/bin/lncli

# Crear directorio de configuración y datos
RUN mkdir -p /root/.lnd && \
    mkdir -p /data/lnd

# Copiar configuración
COPY config/lnd.conf /root/.lnd/lnd.conf

# Script de entrada
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Puertos: Lightning (9735), REST (8080), gRPC (10009)
EXPOSE 9735 8080 10009

# Volumen para datos de LND
VOLUME /data

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

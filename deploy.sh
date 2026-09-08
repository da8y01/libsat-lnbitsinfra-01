#!/bin/bash
set -e

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SECTION="$1"
LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cargar variables sensibles desde .env
if [ -f "$LOCAL_DIR/.env" ]; then
    set -a
    source "$LOCAL_DIR/.env"
    set +a
else
    echo -e "${RED}Error: Archivo .env no encontrado en $LOCAL_DIR${NC}"
    exit 1
fi

echo -e "${YELLOW}=== Setup de Infraestructura LNBits (Bitcoin Core + LND) ===${NC}"
echo "Directorio del proyecto: $LOCAL_DIR"
echo ""

# Función para verificar requisitos
check_requirements() {
    echo -e "${YELLOW}[1/5] Verificando requisitos...${NC}"
    if ! command -v docker &>/dev/null; then
        echo -e "${RED}Error: Docker no está instalado. Instale Docker primero.${NC}"
        exit 1
    fi
    if ! docker compose version &>/dev/null; then
        echo -e "${RED}Error: Docker Compose no está disponible.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Docker y Docker Compose disponibles${NC}"
    echo ""
}

# Función para construir imágenes
build_images() {
    echo -e "${YELLOW}[2/5] Construyendo imágenes de Docker...${NC}"
    docker compose -f "$LOCAL_DIR/docker-compose.yml" build
    echo -e "${GREEN}✓ Imágenes construidas exitosamente${NC}"
    echo ""
}

# Función para levantar servicios
start_services() {
    echo -e "${YELLOW}[3/5] Levantando servicios de la infraestructura...${NC}"
    docker compose -f "$LOCAL_DIR/docker-compose.yml" up -d
    echo -e "${GREEN}✓ Servicios iniciados${NC}"
    echo ""
}

# Función para verificar contenedores
check_containers() {
    echo -e "${YELLOW}[4/5] Verificando estado de los contenedores...${NC}"
    sleep 10
    docker compose -f "$LOCAL_DIR/docker-compose.yml" ps
    echo ""
}

# Función para ejecutar verificaciones básicas
verify_services() {
    echo -e "${YELLOW}[5/5] Ejecutando verificaciones de servicios...${NC}"

    # Verificar Bitcoin Core
    echo -e "${YELLOW}→ Verificando Bitcoin Core...${NC}"
    if docker exec bitcoind bitcoin-cli -testnet4 -datadir=/data/bitcoin -rpcuser="${BITCOIN_RPC_USER}" -rpcpassword="${BITCOIN_RPC_PASSWORD}" getblockchaininfo &>/dev/null; then
        echo -e "  ${GREEN}✓ bitcoind responde correctamente${NC}"
        docker exec bitcoind bitcoin-cli -testnet4 -datadir=/data/bitcoin -rpcuser="${BITCOIN_RPC_USER}" -rpcpassword="${BITCOIN_RPC_PASSWORD}" getblockchaininfo | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'  Red: {d[\"chain\"]}, Bloques: {d[\"blocks\"]}, Prune en altura: {d[\"pruneheight\"]}')" 2>/dev/null || echo "  (detalles no disponibles)"
    else
        echo -e "  ${RED}✗ bitcoind no responde aún. Puede estar sincronizando...${NC}"
    fi

    # Verificar LND
    echo -e "${YELLOW}→ Verificando LND...${NC}"
    if docker exec lnd lnclictl getinfo &>/dev/null; then
        echo -e "  ${GREEN}✓ lnd responde correctamente${NC}"
        docker exec lnd lnclictl getinfo | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'  Alias: {d[\"alias\"]}, Peers: {d[\"num_peers\"]}, Channels: {d[\"num_active_channels\"]}')" 2>/dev/null || echo "  (LND aún no desbloqueado, ejecute lnclictl create)"
    elif docker exec lnd lncli --network=testnet4 --rpcserver=localhost:10009 --tlscertpath=/data/lnd/tls.cert getinfo 2>&1 | grep -qi "no such file\|wallet"; then
        echo -e "  ${YELLOW}○ lnd ejecutándose y escuchando (requiere crear la wallet con: docker exec -it lnd lnclictl create)${NC}"
    else
        echo -e "  ${RED}✗ lnd no responde aún. Ejecutar lnclictl create para crear wallet${NC}"
    fi

    # Verificar Tor
    echo -e "${YELLOW}→ Verificando TOR...${NC}"
    if docker exec ubuntu-tor-ssh pgrep -x tor &>/dev/null; then
        echo -e "  ${GREEN}✓ Tor ejecutándose${NC}"
    elif docker exec ubuntu-tor-ssh pgrep -f "/usr/bin/tor" &>/dev/null; then
        echo -e "  ${GREEN}✓ Tor ejecutándose${NC}"
    else
        # Verificar Tor de forma genérica
        if docker exec ubuntu-tor-ssh test -f /etc/tor/torrc &>/dev/null; then
            echo -e "  ${YELLOW}○ Tor configurado pero el proceso no está activo${NC}"
        else
            echo -e "  ${RED}✗ Tor no detectado${NC}"
        fi
    fi

    echo ""
    echo -e "${GREEN}=== Proceso de despliegue completado ===${NC}"
}

# Ejecutar fases
check_requirements
build_images
start_services
check_containers
verify_services

echo ""
echo -e "${GREEN}Resumen de servicios:${NC}"
echo "  - Bitcoin Core RPC: http://localhost:18332 (testnet4, prune 550 MiB)"
echo "  - LND gRPC: localhost:10009 | REST: http://localhost:8080 | Lightning: 9735"
echo "  - SSH: ssh root@localhost (password: ${SSH_PASSWORD})"
echo "  - Tor SOCKS: localhost:9050 | Tor Control: localhost:9051"
echo ""
echo -e "${YELLOW}Pasos siguientes (Fases 3 y 4 del curso):${NC}"
echo "  1) Crear la wallet de LND:   docker exec -it lnd lnclictl create"
echo "     >> GUARDE LA SEMILLA DE 24 PALABRAS EN UN LUGAR SEGURO <<"
echo "  2) Verificar LND:            docker exec lnd lnclictl getinfo"
echo "  3) Generar dirección para financiar (FASE 4):"
echo "     docker exec lnd lnclictl newaddress p2wkh"
echo "     -> Use esa dirección en un faucet de testnet4, p.ej: https://coinfaucet.eu/en/btc-testnet4/"
echo ""
echo "Para ver los logs: docker compose logs -f"

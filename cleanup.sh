#!/bin/bash
set -e

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${YELLOW}=== Limpieza de infraestructura LNBits ===${NC}"
echo ""

# Verificar que docker compose está disponible
if ! docker compose version &>/dev/null; then
    echo -e "${RED}Error: Docker Compose no está disponible.${NC}"
    exit 1
fi

# Preguntar al usuario si desea eliminar volúmenes de datos
echo -e "${YELLOW}ADVERTENCIA: Desea eliminar también los datos persistidos (volúmenes)?${NC}"
echo "  Esta acción eliminará la cadena de bloques sincronizada y la wallet de LND."
read -p "¿Eliminar volúmenes de datos? (s/N): " -n 1 -r
echo ""
DELETE_VOLUMES=false
if [[ $REPLY =~ ^[Ss]$ ]]; then
    DELETE_VOLUMES=true
fi

echo -e "${YELLOW}[1/4] Deteniendo servicios...${NC}"
if [ -n "$(docker compose -f "$LOCAL_DIR/docker-compose.yml" ps -q 2>/dev/null)" ]; then
    docker compose -f "$LOCAL_DIR/docker-compose.yml" down
fi
echo -e "${GREEN}✓ Servicios detenidos${NC}"
echo ""

echo -e "${YELLOW}[2/4] Deteniendo y eliminando contenedores...${NC}"
docker compose -f "$LOCAL_DIR/docker-compose.yml" rm -f || true
echo -e "${GREEN}✓ Contenedores eliminados${NC}"
echo ""

echo -e "${YELLOW}[3/4] Eliminando imágenes de Docker...${NC}"
docker compose -f "$LOCAL_DIR/docker-compose.yml" down --rmi all >/dev/null 2>&1 || true
echo -e "${GREEN}✓ Imágenes eliminadas${NC}"
echo ""

if [ "$DELETE_VOLUMES" = true ]; then
    echo -e "${YELLOW}[4/4] Eliminando volúmenes de datos...${NC}"
    docker compose -f "$LOCAL_DIR/docker-compose.yml" down -v >/dev/null 2>&1 || true
    echo -e "${GREEN}✓ Volúmenes de datos eliminados${NC}"
else
    echo -e "${YELLOW}[4/4] Volúmenes de datos preservados (conservando datos persistidos)${NC}"
fi
echo ""

echo -e "${GREEN}=== Limpieza completada ===${NC}"
echo ""
if [ "$DELETE_VOLUMES" = false ]; then
    echo "Los datos persistidos están en los volúmenes Docker:"
    docker volume ls | grep -E "bitcoin_data|lnd_data|tor_data" 2>/dev/null || echo "  (sin volúmenes encontrados)"
fi

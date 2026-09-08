# Infraestructura LNbits (Bitcoin Core + LND)

Infraestructura Docker para soportar una arquitectura de aplicaciones de Bitcoin que incluye **Bitcoin Core**, **LND (Lightning Network Daemon)** y, en fases futuras, **LNbits**.

Esta infraestructura se construye de forma incremental según un curso con fases iterativas. Cada fase agrega componentes sobre las anteriores:

1. **Fase 1**: Sistema operativo Ubuntu + TOR + SSH.
2. **Fase 2**: Bitcoin Core en red TestNet4 con modo *prune* (550 MiB).
3. **Fase 3**: LND (Lightning Network Daemon).
4. **Fase 4**: Financiación del nodo (faucets de TestNet4 - proceso manual documentado).

## Requisitos previos

- **Docker** instalado y funcionando.
- **Docker Compose** (plugin) disponible.
- Al menos **2 GB de RAM libre** y **~2 GB de espacio en disco** (por el modo prune y las imágenes Docker).
- Conexión a Internet para descargar imágenes y dependencias.

Verificá que Docker esté disponible:

```bash
docker --version
docker compose version
```

## Estructura del proyecto

```
.
├── .env                        # Variables sensibles (NO subir al repo)
├── docker-compose.yml          # Orquestación de los 3 servicios
├── deploy.sh                   # Construye y levanta la infraestructura con verificaciones
├── cleanup.sh                  # Detiene y limpia los recursos
├── phase1-base/                # FASE 1: Ubuntu + TOR + SSH
│   ├── Dockerfile
│   ├── docker-entrypoint.sh    # Templa torrc con variables del .env
│   └── config/torrc
├── phase2-bitcoin/             # FASE 2: Bitcoin Core (TestNet4, prune 550 MiB)
│   ├── Dockerfile (multi-stage)
│   ├── config/bitcoin.conf
│   └── docker-entrypoint.sh
├── phase3-lnd/                 # FASE 3: LND
│   ├── Dockerfile (multi-stage)
│   ├── config/lnd.conf
│   └── docker-entrypoint.sh
└── README.md
```

## Servicios que levanta

| Servicio | Container | Puerto(s) | Descripción |
|----------|-----------|-----------|-------------|
| base     | `ubuntu-tor-ssh` | 22 (SSH), 9050 (TOR SOCKS), 9051 (TOR Control) | Ubuntu + TOR + SSH |
| bitcoind | `bitcoind` | 18332 (RPC), 48333 (P2P), 28332/28333 (ZMQ) | Bitcoin Core TestNet4, prune 550 MiB |
| lnd      | `lnd` | 9735 (Lightning), 8080 (REST), 10009 (gRPC) | Lightning Network Daemon |

## Cómo ejecutar

### 1. Construir y levantar la infraestructura

La forma más sencilla es usar el script de despliegue:

```bash
./deploy.sh
```

El script realiza las siguientes verificaciones automáticas:
1. Comprueba que Docker y Docker Compose estén disponibles.
2. Construye todas las imágenes (multi-stage).
3. Levanta los tres servicios.
4. Muestra el estado de los contenedores.
5. Verifica que `bitcoind`, `lnd` y Tor respondan.

### 2. Comandos individuales (alternativa)

Construir las imágenes:

```bash
docker compose build
```

Levantar los servicios en segundo plano:

```bash
docker compose up -d
```

Ver el estado:

```bash
docker compose ps
```

Ver los logs en tiempo real:

```bash
docker compose logs -f
```

### 3. Verificaciones realizadas y su resultado

La infraestructura se probó de punta a punta. Resultados observados:

**Estado de contenedores:**
```
NAME             STATUS                    PORTS
bitcoind         Up (healthy)              0.0.0.0:18332->18332, 28332-28333, 48333
lnd              Up (healthy)              0.0.0.0:9735, 8080, 10009
ubuntu-tor-ssh   Up (healthy)              0.0.0.0:22, 9050, 9051
```

**Bitcoin Core (Fase 2)** — `bitcoin-cli -testnet4 getblockchaininfo` responde:
```json
{
    "chain": "testnet4",
    "blocks": 18691,
    "pruned": true,
    "prune_target_size": 576716800
}
```
Confirma red TestNet4 y modo prune activo con objetivo de **550 MiB** (`576716800` bytes).

**TOR (Fase 1)** — verificación de anonimización a través del SOCKS proxy:
```json
{"IsTor":true,"IP":"185.220.101.13"}
```
(devuelve una IP de un nodo de salida de Tor).

**LND (Fase 3)** — levanta y escucha en gRPC (10009), REST (8080) y Lightning (9735). Al primer arranque queda **esperando la creación de la wallet** (comportamiento esperado):
```
[INF] RPCS: RPC server listening on 0.0.0.0:10009
[INF] LTND: Waiting for wallet encryption password. Use `lncli create` to create a wallet...
```

**Comandos manuales de verificación por servicio:**

```bash
# Bitcoin Core (credenciales en .env)
docker exec bitcoind bitcoin-cli -testnet4 -datadir=/data/bitcoin \
  -rpcuser=${BITCOIN_RPC_USER} -rpcpassword=${BITCOIN_RPC_PASSWORD} getblockchaininfo

# LND (wrapper lnclictl incluye los paths de TLS y macaroon)
docker exec lnd lnclictl getinfo

# Tor funciona (devuelve una IP distinta vía Tor)
docker exec ubuntu-tor-ssh torsocks curl -s https://check.torproject.org/api/ip

# SSH al contenedor base (password en .env: SSH_PASSWORD)
ssh root@localhost
```

> **Primera vez (LND)**: cree la wallet con `lnclictl create`. **Guarde la semilla de 24 palabras en un lugar seguro**, es la única forma de recuperar los fondos.

> **Tras cada reinicio del contenedor `lnd`**: la wallet vuelve a quedar cifrada (diseño de seguridad de LND: la password no se guarda en disco). Para retomarla tras un `docker compose up` o `docker restart lnd`:

```bash
docker exec -it lnd lnclictl unlock      # ingresar la password de la wallet
docker exec lnd lnclictl getinfo         # debe responder con el alias
```

### 4. FASE 4: Financiar el nodo (proceso manual)

Para financiar el nodo con satoshis (TestNet4), primero cree la wallet y luego genere una dirección:

```bash
# Crear la wallet (interactivo; la semilla de 24 palabras debe guardarse)
docker exec -it lnd lnclictl create

# Verificar que LND quedó listo
docker exec lnd lnclictl getinfo

# Generar una dirección de recepción
docker exec lnd lnclictl newaddress p2wkh
```

Copie la dirección en un faucet de TestNet4, por ejemplo:
- https://coinfaucet.eu/en/btc-testnet4/

Espere la confirmación y verifique el saldo:

```bash
docker exec lnd lnclictl walletbalance
```

Repita con varios faucets para juntar suficiente saldo y abrir canales con buena liquidez. Si un faucet limita por IP, reinicie la navegación a través de TOR para obtener una IP distinta. Si limita por dirección (`Next withdrawal for address`), genere una dirección nueva antes de intentar de nuevo:

```bash
docker exec lnd lnclictl newaddress p2wkh
```

Cada ejecución genera una dirección distinta derivada de la misma wallet. Todas las direcciones reciben fondos en la misma wallet.

## Cómo detener y limpiar

Usar el script de limpieza (recomendado):

```bash
./cleanup.sh
```

El script preguntará si desea eliminar también los **volúmenes de datos** (cadena de bloques sincronizada y wallet de LND). Responda `s` solo si está seguro.

Alternativas con comandos directos:

```bash
# Detener servicios (conserva datos e imágenes)
docker compose stop

# Detener y eliminar contenedores + imágenes (conserva volúmenes con -v omitido)
docker compose down --rmi all

# Detener y eliminar todo, incluidos los volúmenes de datos
docker compose down -v --rmi all
```

> **ADVERTENCIA**: `down -v` elimina permanentemente la blockchain sincronizada y la wallet de LND. Si no guardó la semilla, perderá los fondos.

## Persistencia de datos

Los datos se conservan en volúmenes Docker nombrados, para que sobrevivan al reinicio de contenedores:

- `tor_data`: directorio de datos de Tor (`/var/lib/tor`).
- `bitcoin_data`: blockchain TestNet4 y configuración (`/data/bitcoin`).
- `lnd_data`: wallet y configuración de LND (`/data/lnd`).

## Notas de seguridad

- Las credenciales (RPC de Bitcoin Core y control de Tor) se centralizan en el archivo `.env`. **No lo suba al repositorio** (ya está en `.gitignore`) ni lo use en mainnet; son de prueba para TestNet4.
- El ControlPort de Tor (`0.0.0.0:9051`) usa un **HashedControlPassword** de laboratorio (`TOR_HASHED_CONTROL_PASSWORD` en `.env`). Tor **no permite** un ControlPort sin autenticación en direcciones no-locales, por lo que se requiere password. Solo es accesible dentro de la red Docker interna `lnbits_network`; no se publica al host.
- Los puertos 9050 (TOR SOCKS) y 9051 (TOR control) están expuestos al host vía `ports` en el compose. Para mayor seguridad restrínjalos a `127.0.0.1:9050:9050`.
- El SSH del contenedor base usa la contraseña definida en `SSH_PASSWORD` del `.env`. Cámbiela antes de exponer el puerto 22 a redes no confiables.

> **Nota sobre LND y Tor**: LND (`tor.active=1`) necesita el Tor controller para crear su servicio oculto v3. Por eso apunta a `tor.socks=base:9050` y `tor.control=base:9051` con la password `TOR_PASSWORD` del `.env`. Si se cambia la password, debe regenerarse el hash (`tor --hash-password`), actualizar `TOR_HASHED_CONTROL_PASSWORD` en el `.env` y actualizar `TOR_PASSWORD`.

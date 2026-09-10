# Infraestructura LNbits (Bitcoin Core + LND)

[Librería de Satoshi](https://moodle.libreriadesatoshi.com/), curso "Bitcoin Core, LND y LNbits: De cero a infraestructura real".

Infraestructura Docker para soportar una arquitectura de aplicaciones de Bitcoin que incluye **Bitcoin Core**, **LND (Lightning Network Daemon)** y, en fases futuras, **LNbits**.

## CLI de IA

Se usó [OpenCode](https://opencode.ai/) con el modelo `OpenCode Zen` y el siguiente prompt:

```
## Primer prompt:

Se requiere hacer el setup de una infraestructura para soportar una arquitectura de aplicaciones que incluyen principalmente: Bitcoin Core, LND y LNbits.
El requerimiento viene de un curso que tiene fases iterativas para montar la infraestructura requerida en pasos incrementales que deben seguirse, es decir, primero se hace la configuración de un componente, y luego secuencialmente se agregan otros componentes necesarios para obtener la arquitectura objetivo.
Primero se usará Docker y Docker Compose para los intentos y pruebas iniciales, después cuando se tenga una infraestructura estable que soporte la arquitectura objetivo (Bitcoin Core, LND y LNbits), es posible que se requiera reproducir la infraestructura fuera de Docker directamente en la máquina "host".
Primero se debe hacer y explicar el plan, y solamente después de revisar y verificar ese plan, se pasaría a ejecutarlo.

Los pasos incrementales o fases requeridas por el curso que deben seguirse son cuatro que a continuación se listan, pero que posteriormente se ampliarán y describirán en mayor detalle:
1. Configuración de SO (Sistema Operativo) Ubuntu, junto con TOR y SSh.
2. Instalación y configuración de Bitcoin Core usando la red "TestNet4", y usando el modo prune (poda) de la block chain para moderar el espacio de almacenamiento en disco físico utilizado por el nodo Bitcoin.
3. Instalación y configuración de LND (Lightning Network Daemon).
4. Financiación del recientemente creado y configurado nodo Bitcoin por medio de faucets, para tener suficiente saldo o balance para abrir y operar canales, tener suficientes "satoshis" para los fees (comisiones) y para hacer algunas transacciones de prueba.
Además de estas cuatro fases iniciales, quedarán faltando otras fases posteriores, las que incluirán la instalación y configuración de LNbits y otras aplicaciones requeridas, pero estas futuras fases todavía no se implementarán.

Instrucciones detalladas de las cuatro fases iniciales para montar la infraestructura requerida para obtener la arquitectura objetivo (Bitcoin Core, LND y LNbits):

1. Configuración de SO (Sistema Operativo) Ubuntu, junto con TOR y SSh.
Se debe analizar el archivo "modulo_3_linux_tor.md" contenido en este mismo directorio del proyecto actual, para ver las sugerencias y detalles de las instalaciones, configuraciones y requerimientos de esta primera fase.
Se deben generar tanto un Dockerfile como un archivo compose.yml apropiados para esta primera fase.

2. Instalación y configuración de Bitcoin Core usando la red "TestNet4", y usando el modo prune (poda) de la block chain para moderar el espacio de almacenamiento en disco físico utilizado por el nodo Bitcoin.
Se debe analizar el archivo "modulo_4_bitcoin_core.md" contenido en este mismo directorio del proyecto actual, para ver las sugerencias y detalles de las instalaciones, configuraciones y requerimientos de esta segunda fase. Se deben tener en cuenta los archivos de configuración necesarios, y ensayar y verificar el funcionamiento de las aplicaciones recién instaladas y configuradas.
Se deben generar nuevos o actualizar los existentes archivos Dockerfile y compose.yml que sean apropiados para esta segunda fase. Si es necesario y adecuado generar "multi-stage" Dockerfile y compose.yml . Tener en cuenta que un aspecto importante de esta fase, es configurar el nodo Bitcoin Core en modo prune (o podado) con un tamaño máximo propuesto de 550 MiB.

3. Instalación y configuración de LND (Lightning Network Daemon).
Se debe analizar el archivo "modulo_5_lnd_lightning.md" contenido en este mismo directorio del proyecto actual, para ver las sugerencias y detalles de las instalaciones, configuraciones y requerimientos de esta tercera fase. Se deben tener en cuenta requisitos como las dependencias y herramientas de compilación, el entorno "Go lang", el archivo de configuración necesario, y el ensayo y verificación del funcionamiento de las herramientas instaladas y configuradas.

4. Financiación del recientemente creado y configurado nodo Bitcoin por medio de faucets, para tener suficiente saldo o balance para abrir y operar canales, tener suficientes "satoshis" para los fees (comisiones) y para hacer algunas transacciones de prueba.
Ver el archivo "modulo_6_financiar_nodo.md" contenido en este mismo directorio del proyecto actual, para ver algunas sugerencias e información adicional con respecto a esta cuarta fase consistente en financiar el nodo para poder ejecutar operaciones y transacciones básicas. De ser necesario usar el truco de reiniciar la navegación con TOR para tener una IP distinta y poder acceder de nuevo a satoshis proveídos por los diferentes faucets (grifos).

Generar dos scripts:
- deploy.sh : Para lanzar la infraestructura y arquitectura diseñada, con las verificaciones básicas.
- cleanup.sh : Para detener, eliminar y en general liberar y limpiar los recursos usados por esta infraestructura.

Generar un archivo .gitignore adecuado para este proyecto.

Generar un archivo README.md para permitir que otra persona construya y ejecute el proyecto sin consultar a quien lo escribió. Debe incluir: descripción del proyecto, requisitos previos, explicar cómo ejecutar las aplicaciones, comandos para construir y correr la arquitectura de aplicaciones diseñada, verificaciones realizadas y su resultado, cómo detener y limpiar los recursos usados.

Como ya se había estipulado: Primero se debe hacer y explicar el plan, y solamente después de revisar y verificar ese plan, se pasaría a ejecutarlo.

## Segundo prompt:

Continuando con este proyecto incremental basado en los pasos de un curso de referencia, la Fase 5 sería: Integrar dos clientes web (RTL y satoshi-odyssey) al proyecto.
Integrar las siguientes dos aplicaciones web que son clientes web para gestión de LND, como servicios al compose del proyecto:
1. RTL (https://github.com/Ride-The-Lightning/RTL).
2. satoshi-odyssey (https://github.com/btcol/satoshi-odyssey).
Tener en cuenta, si las hay, dependencias a los otros servicios, posibles puertos repetidos, y verificar que la estructura del proyecto quede estable.
Actualizar el archivo README.md (u otros archivos) en la medida de lo necesario.
Generar y explicar un plan para revisarlo y verificarlo, y posteriormente ejecutarlo.

## Tercer prompt:

La siguiente iteración de este proyecto será Fase 6: Integrar LNbits.
Se deben leer y analizar los archivos "modulo_7_lnbits_backend.md" y "modulo_8_canales_peers.md" donde se encontrarán instrucciones, requerimientos y sugerencias para la instalación, configuración e integración de LNbits.
Tener en cuenta las instrucciones indicadas en "modulo_7_lnbits_backend.md", tales como UV, repositorio y configuración de LNbits, y demás pasos.
Actualizar README.md y otros archivos en la medida de lo necesario.
Generar y explicar un plan para revisarlo y verificarlo, y posteriormente ejecutarlo.
```

Esta infraestructura se construye de forma incremental según un curso con fases iterativas. Cada fase agrega componentes sobre las anteriores:

1. **Fase 1**: Sistema operativo Ubuntu + TOR + SSH.
2. **Fase 2**: Bitcoin Core en red TestNet4 con modo *prune* (550 MiB).
3. **Fase 3**: LND (Lightning Network Daemon).
4. **Fase 4**: Financiación del nodo (faucets de TestNet4 - proceso manual documentado).
5. **Fase 5**: Integración de clientes web para LND: RTL y satoshi-odyssey.
6. **Fase 6**: Integración de LNbits (backend de wallets, instalado desde fuente con UV).

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
├── docker-compose.yml          # Orquestación de los servicios
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
├── phase5-rtl/                 # FASE 5: RTL (cliente web)
│   └── config/
│       └── RTL-Config.json.template   # Templa la config antes de arrancar RTL
├── phase5-satodyssey/          # FASE 5: satoshi-odyssey (cliente web)
│   ├── Dockerfile              # Flask + jq + lncli v0.19.0-beta
│   └── lncli-remote            # Wrapper lncli → contenedor lnd
├── phase6-lnbits/              # FASE 6: LNbits (backend de wallets)
│   └── Dockerfile              # Build desde fuente con UV (tag v1.5.6)
└── README.md
```

## Servicios que levanta

| Servicio | Container | Puerto(s) | Descripción |
|----------|-----------|-----------|-------------|
| base     | `ubuntu-tor-ssh` | 22 (SSH), 9050 (TOR SOCKS), 9051 (TOR Control) | Ubuntu + TOR + SSH |
| bitcoind | `bitcoind` | 18332 (RPC), 48333 (P2P), 28332/28333 (ZMQ) | Bitcoin Core TestNet4, prune 550 MiB |
| lnd      | `lnd` | 9735 (Lightning), 8080 (REST), 10009 (gRPC) | Lightning Network Daemon |
| rtl          | `rtl` | 3000 (web) | Cliente web RTL para LND |
| satoshi-odyssey | `satoshi-odyssey` | 9630 (web) | Dashboard web satoshi-odyssey para LND |
| lnbits      | `lnbits` | 5000 (web) | LNbits: backend de wallets sobre LND |

> `rtl-config-init` es un contenedor **one-shot** (no se queda ejecutándose): genera `/RTL/config/RTL-Config.json` en el volumen `rtl_config` a partir de la plantilla antes de que arranque RTL.

## Cómo ejecutar

### 1. Construir y levantar la infraestructura

La forma más sencilla es usar el script de despliegue:

```bash
./deploy.sh
```

El script realiza las siguientes verificaciones automáticas:
1. Comprueba que Docker y Docker Compose estén disponibles.
2. Construye todas las imágenes (multi-stage).
3. Levanta los servicios (incluidos RTL, satoshi-odyssey y LNbits).
4. Muestra el estado de los contenedores.
5. Verifica que `bitcoind`, `lnd`, Tor, RTL, satoshi-odyssey y LNbits respondan.

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
rtl              Up (healthy)              0.0.0.0:3000->3000
satoshi-odyssey  Up (healthy)              0.0.0.0:9630->9630
lnbits           Up (healthy)              0.0.0.0:5000->5000
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

# LNbits (Fase 6): responde la aplicación
curl -fsS -o /dev/null http://localhost:${LNBITS_PORT}/ && echo "LNbits OK"
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

### 5. FASE 5: Clientes web para LND (RTL y satoshi-odyssey)

Dos aplicaciones web para gestionar e inspeccionar el nodo LND se integran como servicios del compose:

- **RTL** (Ride The Lightning): interfaz completa de gestión de LND (canales, pagos, rutas, on-chain). Se usa la imagen oficial `shahanafarooqui/rtl:v0.15.11` en `http://localhost:3000`.
- **satoshi-odyssey**: dashboard visual (telemetría, peers, canales). Se construye desde el repo `btcol/satoshi-odyssey` en `http://localhost:9630`.

Ambos montan el volumen `lnd_data` en **solo lectura** (`/data`, igual que el contenedor `lnd`) para leer el `admin.macaroon`, el `tls.cert` y el `lnd.conf` del nodo (ubicados en `/data/lnd`). Todos los servicios comparten la red interna `lnbits_network`; los clientes apuntan a `https://lnd:8080` (REST) y a `lnd:10009` (gRPC).

**Acceso y credenciales** (definidas en `.env`):

| Cliente | URL | Credencial |
|---------|-----|------------|
| RTL | http://localhost:3000 | `RTL_MULTIPASS` |
| satoshi-odyssey | http://localhost:9630 | `SATODYSSEY_USER` / `SATODYSSEY_PASS` (HTTP Basic) |

**Dependencias y notas de implementación:**

- RTL conecta por REST (`lnServerUrl: https://lnd:8080`) con el `admin.macaroon`; TLS autofirmado de LND es aceptado sin configuración extra y el `tls.cert` se resuelve automáticamente desde el directorio de LND montado.
- RTL **reescribe su `RTL-Config.json` al arrancar** (un mount de solo lectura lo haría salir con `EROFS`). Por eso un contenedor one-shot `rtl-config-init` templa la plantilla `phase5-rtl/config/RTL-Config.json.template` (sustituye `__RTL_MULTIPASS__` y `__LND_ALIAS__`) en el volumen `rtl_config`, que RTL usa y modifica libremente.
- satoshi-odyssey invoca `lncli` a través del wrapper `phase5-satodyssey/lncli-remote` (conecta a `lnd:10009` con `tls.cert` y macaroons) y además usa el REST de LND (`LND_REST_HOST=https://lnd:8080`). El Dockerfile no se limita al original: añade `jq` y el binario `lncli` v0.19.0-beta (igual que el LND del proyecto).
- En esta fase solo se incluye el **dashboard** web de satoshi-odyssey (no el servicio *collector*); las estadísticas históricas/CSV que genera el collector se crearán únicamente si se ejecutan sus scripts manualmente.
- La wallet de LND debe estar **creada y desbloqueada** para que los clientes muestren datos (`docker exec -it lnd lnclictl unlock`). Mientras esté cifrada, ambos UIs siguen cargando pero muestran el error del nodo "wallet locked".

**Verificación (la ejecuta `deploy.sh`):**

```bash
# RTL responde (página de login)
curl -fsS -o /dev/null http://localhost:3000/ && echo "RTL OK"

# satoshi-odyssey: sin credenciales pide autenticación (401)...
curl -s -o /dev/null -w '%{http_code}\n' http://localhost:9630/
# ...y con credenciales responde 200
curl -fsS -u "${SATODYSSEY_USER}:${SATODYSSEY_PASS}" -o /dev/null http://localhost:9630/ && echo "satoshi-odyssey OK"

# Conectividad de satoshi-odyssey a LND (gRPC a lnd:10009):
# con la wallet bloqueada debe devolver un error tipo "wallet locked" (¡conexión OK!)
docker exec satoshi-odyssey /usr/local/bin/lncli-remote --network=testnet4 getinfo

# Logs de RTL
docker compose logs rtl
```

### 6. FASE 6: LNbits (backend de wallets)

LNbits es un servidor Python que se sitúa sobre la fuente de financiación LND y proporciona wallets aisladas, una API limpia y un sistema de extensiones. Se integra como servicio del compose siguiendo las instrucciones del **módulo 7** (`modulo_7_lnbits_backend.md`): instalación desde el repositorio oficial con **UV**, y configuración de la fuente de financiación **manual** desde la UI.

**Cómo se construye** (`phase6-lnbits/Dockerfile`, multi-stage):

- Imagen base `python:3.12-slim-bookworm`.
- Instala **UV** (`curl -LsSf https://astral.sh/uv/install.sh | sh`).
- `git clone --depth 1 --branch ${LNBITS_VERSION}` del repo `lnbits/lnbits` (versión por defecto `v1.5.6`, configurable con `LNBITS_VERSION` en el `.env`).
- `uv sync --all-extras` (instala todas las extensiones, igual que el módulo 7).
- Arranque con `uv run lnbits` en `http://localhost:5000` (`HOST=0.0.0.0`).
- Corre como **root** (igual que la imagen oficial) para poder leer el `admin.macaroon` y el `tls.cert` de LND (ficheros `0600` de root) desde el volumen `lnd_data` montado en solo lectura.

**Acceso y primer arranque:**

1. Abra `http://localhost:5000`. En el primer acceso LNbits muestra el **asistente de creación del administrador** (email + password). Es ese usuario quien gestiona la configuración del servidor.
2. Los datos de LNbits (base de datos SQLite, settings, extensiones) se guardan en el volumen `lnbits_data` (`/app/data`), de modo que sobreviven a reinicios.

**Fuente de financiación (módulo 7, paso manual):**

En la UI diríjase a **Settings → Funding Sources**, seleccione **Lightning Network Daemon (LND Rest)** e introduzca los siguientes valores (**paths dentro del contenedor**, donde `lnd_data` está montado en `/data` en solo lectura):

| Campo | Valor |
|-------|-------|
| Endpoint | `https://lnd:8080` |
| Certificate | `/data/lnd/tls.cert` |
| Macaroon | `/data/lnd/data/chain/bitcoin/testnet4/admin.macaroon` |

Oprima **SAVE**. La wallet de LND debe estar **desbloqueada** para operar (`docker exec -it lnd lnclictl unlock`); mientras esté cifrada el backend reportará "wallet locked".

> En el despliegue local, el certificado autofirmado de LND es aceptado porque LNbits lo usa como certificado de confianza (pinning) y el binario REST de LND responde con SAN `DNS:lnd`.

**Referencia (módulo 8) — operar canales y peers:**

Comandos de `lncli` (el wrapper `lnclictl` ya incluye `--network=testnet4` y los paths del contenedor):

```bash
# Conectar a un nodo (P2P)
docker exec lnd lnclictl connect <pubkey>@<host>:<port>

# Abrir un canal (v1, compatibilidad)
docker exec lnd lnclictl openchannel <pubkey> <local_amt_sat> <push_amt_sat>

# Explorar la red: grafo, nodos y rutas
docker exec lnd lnclictl describegraph
docker exec lnd lnclictl getnodeinfo <pubkey>
```

Para una gestión más avanzada del nodo se recomienda el repo de cabina de control `https://github.com/btcol/lightning-tools`. Conceptos profundos de canales y liquidez en `gestion_de_canales.md` y `liquidez_lightning.md`.

**Verificación (la ejecuta `deploy.sh`):**

```bash
# LNbits responde (asistente de admin al primer acceso)
curl -fsS -o /dev/null http://localhost:5000/ && echo "LNbits OK"

# Confirmar que el contenedor puede leer las credenciales de LND para el funding manual
docker exec lnbits sh -c 'ls -l /data/lnd/tls.cert /data/lnd/data/chain/bitcoin/testnet4/admin.macaroon'

# Logs
docker compose logs lnbits
```

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
- `lnd_data`: wallet y configuración de LND (`/data/lnd`). También lo montan **en solo lectura** los clientes web (`/data`).
- `rtl_config`: config dinámica de RTL que él mismo reescribe (`/RTL/config`).
- `rtl_db`: base de datos del dashboard de RTL (`/RTL/database`).
- `satoshi_data`: datos del dashboard de satoshi-odyssey (`/app/data`).
- `lnbits_data`: base de datos SQLite, settings y extensiones de LNbits (`/app/data`). También monta `lnd_data` en **solo lectura** (`/data`) para el funding manual.

## Notas de seguridad

- Las credenciales (RPC de Bitcoin Core y control de Tor) se centralizan en el archivo `.env`. **No lo suba al repositorio** (ya está en `.gitignore`) ni lo use en mainnet; son de prueba para TestNet4.
- El ControlPort de Tor (`0.0.0.0:9051`) usa un **HashedControlPassword** de laboratorio (`TOR_HASHED_CONTROL_PASSWORD` en `.env`). Tor **no permite** un ControlPort sin autenticación en direcciones no-locales, por lo que se requiere password. Solo es accesible dentro de la red Docker interna `lnbits_network`; no se publica al host.
- Los puertos 9050 (TOR SOCKS) y 9051 (TOR control) están expuestos al host vía `ports` en el compose. Para mayor seguridad restrínjalos a `127.0.0.1:9050:9050`.
- El SSH del contenedor base usa la contraseña definida en `SSH_PASSWORD` del `.env`. Cámbiela antes de exponer el puerto 22 a redes no confiables.
- Los clientes web de la Fase 5 usan credenciales del `.env` (`RTL_MULTIPASS`, `SATODYSSEY_USER`/`SATODYSSEY_PASS`). RTL **rechaza contraseñas débiles** (`password`, `changeme`, `moneyprintergobrrr`) y obliga a cambiarlas; use contraseñas de laboratorio robustas. Ambos servicios montan `lnd_data` en **solo lectura** para no alterar el nodo, pero cualquier persona con acceso a la UI podrá operar fondos (RTL) o leer el estado del nodo (ambos) si la wallet está desbloqueada.
- LNbits (Fase 6) usa `AUTH_HTTPS_ONLY=false` para permitir el login por HTTP en `http://localhost:5000` (como indica el módulo 7). El administrador se crea en el primer acceso a la UI y sus credenciales viven en la base de datos local (volumen `lnbits_data`). Si va a exponer LNbits más allá de la red local, active `AUTH_HTTPS_ONLY=true` (o un proxy con TLS) y no deje puertos abiertos. LNbits monta `lnd_data` en **solo lectura**, pero quien acceda al admin podrá operar los fondos de la wallet si esta está desbloqueada.

> **Nota sobre LND y Tor**: LND (`tor.active=1`) necesita el Tor controller para crear su servicio oculto v3. Por eso apunta a `tor.socks=base:9050` y `tor.control=base:9051` con la password `TOR_PASSWORD` del `.env`. Si se cambia la password, debe regenerarse el hash (`tor --hash-password`), actualizar `TOR_HASHED_CONTROL_PASSWORD` en el `.env` y actualizar `TOR_PASSWORD`.

# Módulo 4. Bitcoin Core y configuración

## 1. Instalación de herramientas necesarias
Primero, asegúrate de tener las herramientas básicas instaladas. GNUPG es esencial para la verificación de firmas.
```bash
sudo apt update
sudo apt install -y wget gnupg git
```

## 2. Preparación y descarga de archivos
Todo se hará en una carpeta temporal `~/tmp/bitcoin`:
```bash
mkdir -p ~/tmp/bitcoin && cd ~/tmp/bitcoin
wget https://bitcoincore.org/bin/bitcoin-core-30.2/bitcoin-30.2-x86_64-linux-gnu.tar.gz
wget https://bitcoincore.org/bin/bitcoin-core-30.2/SHA256SUMS
wget https://bitcoincore.org/bin/bitcoin-core-30.2/SHA256SUMS.asc
```

## 3. Importación de claves de desarrolladores de Bitcoin
Clona el repositorio para obtener todas las claves usadas para firmar cada versión y navega a la carpeta con las claves:
```bash
git clone https://github.com/bitcoin-core/guix.sigs
cd guix.sigs/30.2/ && cd ../..
```

Descargue las llaves de los firmantes del proyecto Bitcoin core:
```bash
gpg --keyserver keyserver.ubuntu.com --recv-keys \
0CCBAAFD76A2ECE2CCD3141DE2FFD5B1D88CA97D \
152812300785C96444D3334D17565732E08E5E41 \
637DB1E23370F84AFF88CCE03152347D07DA627C \
CFB16E21C950F67FA95E558F2EEB9F5CC09526C1 \
F4FC70F07310028424EFC20A8E4256593F177720 \
D1DBF2C4B96F2DEBF4C16654410108112E7EA81F \
E61773CD6E01040E2F1BD78CE7E2984B6289C93A \
ED9BDF7AD6A55E232E84524257FF9BDBCC301009
```

Ejecute la validación de los binarios:
```bash
gpg --verify SHA256SUMS.asc SHA256SUMS
```
*En el resultado deberá ver el mensaje “Good signature from ...“*

## 4. Instalación final de Bitcoin Core
Una vez verificados los archivos, procede con la instalación:
```bash
tar -xzf bitcoin-30.2-x86_64-linux-gnu.tar.gz
cd bitcoin-30.2/
sudo cp bin/* /usr/local/bin/
```

Verificando instalación:
```bash
bitcoind --version
```

Limpieza (opcional):
```bash
cd ~
rm -rf ~/tmp/bitcoin
```

## 5. Ejecutando bitcoind por primera vez
Prepara el directorio de configuración:
```bash
mkdir -p ~/.bitcoin
nano ~/.bitcoin/bitcoin.conf
```

Agrega la siguiente configuración:
```ini
# Habilitar testnet4
testnet4=1
server=1
txindex=1
daemon=0
maxtfee=0.0001
listenonion=1

# Opcional
# Si desea configurar un nodo podado
# Descomente la siguiente linea y
# Ajuste el valor segun la cantidad de megabytes
# Que va ocupar en su discoduro
#prune=550 # Se expresa en megabytes (MiB)

[testnet4]
# RPC para LND
rpcuser=lnduser
rpcpassword=Unaclavefuerte1
rpcallowip=127.0.0.1
rpcbind=127.0.0.1
rpcport=18332
rpcworkqueue=32
rpcthreads=16

# ZMQ para notificaciones rapidas
zmqpubrawblock=tcp://127.0.0.1:28332
zmqpubrawtx=tcp://127.0.0.1:28333
maxmempool=300
```

Ahora puede ejecutar su nodo:
```bash
bitcoind
```

Para monitorear el estado de su nodo en otra terminal ejecute:
```bash
bitcoin-cli -getinfo
```

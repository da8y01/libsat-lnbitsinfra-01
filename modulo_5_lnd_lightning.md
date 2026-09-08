# Módulo 5. LND y configuración Lightning

## 1. Instalación de Dependencias y Herramientas
Necesitamos instalar los paquetes `build-essential`, `git` y `make` para poder descargar el código y compilarlo.
```bash
sudo apt update
sudo apt install -y build-essential git make
```

## 2. Instalación y Configuración de Go (Golang)
LND está escrito en Go, por lo que necesitamos instalar el entorno de Go.
```bash
cd ~/tmp
wget https://go.dev/dl/go1.23.6.linux-amd64.tar.gz
```
Elimina cualquier instalación previa de Go y extrae la nueva:
```bash
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.23.6.linux-amd64.tar.gz
```
Configura las variables de entorno. Agrega Go a tu PATH editando el archivo `~/.bashrc`:
```bash
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
source ~/.bashrc
```
Puedes verificar que la instalación fue exitosa con:
```bash
go version
```

## 3. Descarga del Código Fuente de LND
Usaremos git para clonar el repositorio oficial de LND en tu GOPATH:
```bash
mkdir -p $HOME/go/src/github.com/lightningnetwork
cd $HOME/go/src/github.com/lightningnetwork
git clone https://github.com/lightningnetwork/lnd.git
cd lnd
```

## 4. Compilación e Instalación de LND
Una vez dentro del directorio del código fuente, usaremos el comando `make`, que automatiza el proceso de compilación e instalación de los binarios `lnd` y `lncli`:
```bash
make
make install
```
Verifica que los binarios quedaron bien instalados en `~/go/bin`:
```bash
ls -la ~/go/bin/lnd ~/go/bin/lncli
```
Agrega `~/go/bin` al PATH:
```bash
echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc
```

## 5. Configuración de LND
Crea el directorio de configuración de LND:
```bash
mkdir -p ~/.lnd
nano ~/.lnd/lnd.conf
```
Agrega la siguiente información en el archivo:
```ini
[Application Options]
alias=ElNombreDeMiNodo-testnet4
listen=localhost
#listen=0.0.0.0:9735
externalip=127.0.0.1:9735
restlisten=127.0.0.1:8080
allow-circular-route=1

tor.active=1
tor.v3=1
tor.skip-proxy-for-clearnet-targets=true

[Bitcoin]
bitcoin.active=true
bitcoin.testnet4=1
bitcoin.node=bitcoind

[Bitcoind]
bitcoind.rpchost=127.0.0.1:18332
bitcoind.rpcuser=lnduser
bitcoind.rpcpass=Unaclavefuerte1
bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332
bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333
```

## 6. Ejecutar y Desbloquear LND
Ejecute en la terminal:
```bash
lnd
```
Se va a generar un mensaje indicando que debes usar `lncli create`. Abra otra terminal y ejecute el siguiente comando para crear una wallet nueva:
```bash
lncli create
```
El proceso te pedirá que configures:
1. **Wallet password**: La contraseña para desbloquear tu cartera.
2. **Confirm password**: Repite la contraseña.
3. **Cipher seed**: Responde `n` (no) porque es la primera vez.
4. **Unlock wallet**: Responde `y` (sí) para desbloquear la cartera.

> [!WARNING]
> Extremadamente importante: Anota y guarda la semilla de 24 palabras en un lugar seguro. Esta es la única manera de recuperar tus fondos si tu nodo falla.

Una vez su instancia LND se esté ejecutando verifique el estado con:
```bash
lncli --network=testnet4 getinfo
```

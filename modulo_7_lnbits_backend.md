# Módulo 7. LNbits instalacion y backend

## 1. Instalación de UV y configuración
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
```
Verifique la instalación con:
```bash
uv --version
```

## 2. Descargue el repositorio de LNbits
```bash
git clone https://github.com/lnbits/lnbits.git
cd lnbits
git checkout main
uv sync --all-extras
```

## 3. Configuración del administrador
Genere el archivo `.env` para configuraciones avanzadas:
```bash
cp .env.example .env
nano .env
```
Acceda al archivo y cambie las siguientes líneas:
```env
AUTH_HTTPS_ONLY=false
HOST=0.0.0.0
```

## 4. Ejecutar el servidor LNbits
Ejecute el servidor LNbits y acceda a la dirección local `http://localhost:5000`:
```bash
uv run lnbits
```
Al ingresar por primera vez a LNbits deberá configurar el usuario administrador.
Para detener el servicio presione `CTRL+C`.

*Para actualizar LNbits (el servicio debe estar detenido):*
```bash
cd lnbits
git pull --rebase
uv sync --all-extras
uv run lnbits
```

## 5. Configurar la fuente de financiación
En la pantalla de LNbits diríjase a:
**Settings → Funding → Funding sources**
Seleccione → **Lightning Network Daemon (LND Rest)**

Abra una terminal y diríjase al directorio `~/.lnd/` y consulte la ruta absoluta:
```bash
cd ~/.lnd/ && pwd
```
Copie la ruta absoluta y agregue al final `/tls.cert` (ej. `/home/ubuntu/.lnd/tls.cert`) y póngalo en el campo Certificate.

Enseguida en el campo “macaroon” agregue la ruta correspondiente:
```
/home/ubuntu/.lnd/data/chain/bitcoin/testnet4/admin.macaroon
```
Finalmente oprima el botón “SAVE” y reinicie el servidor.

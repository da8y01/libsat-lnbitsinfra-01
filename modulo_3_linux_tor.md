# Módulo 3. Preparación del sistema

## Instalación y preparación de Linux (Ubuntu)
Se recomienda el uso de alguno de los dos siguientes SO para una mejor experiencia en el curso.
- Ubuntu Desktop: https://ubuntu.com/download/desktop#main-content
- Guía USB booteable: https://documentation.ubuntu.com/desktop/en/latest/how-to/create-a-bootable-usb-stick/
- Raspberry Pi OS: https://www.raspberrypi.com/software/

## Actualización del sistema
Ejecute en la terminal los siguientes comandos, estos van a actualizar los repositorios y luego instalar todas las actualizaciones disponibles del sistema.
```bash
sudo apt update
sudo apt upgrade
sudo apt full-upgrade
sudo apt autoremove --purge
sudo reboot
```

## Instalar y configurar TOR (Onion)
Este método instala el servicio Tor que se ejecuta en segundo plano, que sirve para anonimizar el tráfico de otras aplicaciones. Es la opción recomendada si quieres proteger tu privacidad a nivel de sistema.

### 1. Actualizar el sistema e identificar arquitectura
```bash
sudo apt update
sudo dpkg --print-architecture
```
Debe mostrar `amd64` (PC estándar) o `arm64` (Raspberry Pi, etc.). Si sale otro resultado, los paquetes oficiales de Tor no serán compatibles.

### 2. Instalar paquetes necesarios y añadir repositorio
```bash
sudo apt install apt-transport-https gnupg wget -y
wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg -dearmor | sudo tee /usr/share/keyrings/deb.torproject.org-keyring.gpg >/dev/null

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/deb.torproject.org-keyring.gpg] https://deb.torproject.org/torproject.org $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/tor-project.list
```
*NOTA: Si tu arquitectura es arm64, elimina `[arch=amd64]` de la línea de comando.*

### 3. Instalar Tor
```bash
sudo apt update
sudo apt install deb.torproject.org-keyring
sudo apt install tor
```

### 4. Configurar Tor
Edita el archivo de configuración principal:
```bash
sudo nano /etc/tor/torrc
```
Asegúrate de descomentar o añadir las siguientes líneas:
```ini
SOCKSPort 9050
DataDirectory /var/lib/tor
ControlPort 9051
CookieAuthentication 0
CookieAuthFileGroupReadable 1
HiddenServiceDir /var/lib/tor/hidden_service/
HiddenServicePort 80 127.0.0.1:5000
```
Guarda y cierra el archivo (`CTRL+O`, `ENTER`, `CTRL+X`).

### 5. Iniciar y probar el servicio
```bash
sudo systemctl enable --now tor
sudo systemctl status tor
```
Prueba tu conexión instalando torsocks:
```bash
sudo apt install torsocks
torsocks curl ifconfig.me
```
Esto mostrará tu IP pública a través de la red Tor.

Reinicia el servicio Tor:
```bash
sudo systemctl restart tor
```

Para ver tu dirección onion generada:
```bash
sudo cat /var/lib/tor/hidden_service/hostname
```
*Guarda bien esta dirección, se usará más adelante.*

## Conexión por SSH
```bash
sudo apt install openssh-server -y
sudo systemctl status ssh
sudo systemctl start ssh
sudo systemctl enable ssh
sudo ufw allow ssh
sudo reboot
```

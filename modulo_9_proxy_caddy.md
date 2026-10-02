# Módulo 9. Clearnet y proxy inverso

Para exponer LNbits a la clearnet, debe obtener un dominio propio de algún proveedor como Hostinger o GoDaddy. Más acerca de la configuración dentro del proveedor de servicio se verá en la clase.

## 1. Configurar Firewall (UFW)
En su servidor, asegúrese de tener los puertos 80 y 443 abiertos:
```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw reload
sudo ufw status verbose # confirma
```

## 2. Instalación de Caddy
Ingrese al siguiente link y siga las instrucciones oficiales para la instalación de Caddy:
[https://caddyserver.com/docs/install#debian-ubuntu-raspbian](https://caddyserver.com/docs/install#debian-ubuntu-raspbian)

## 3. Configurar el Proxy Inverso
Luego ejecute para detener la instancia por defecto y configurarlo hacia LNbits:
```bash
caddy stop
sudo caddy reverse-proxy --from yoururl.com --to :5000
```
Después de esto su distribución LNbits ya es accesible desde su url propia.

*Para una guía teórica de qué significa exponer el servicio en clearnet y otras opciones, consulte el recurso `lnbits_clearnet.md`.*

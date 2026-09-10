# Módulo 8. Operación Lightning, Canales y peers

Los siguientes comandos le permitirán establecer una conexión, abrir canales y explorar los nodos vecinos.

## 1. Conectar a un nodo (establecer conexión P2P)
```bash
lncli --network=testnet4 connect <pubkey>@<host>:<port>
```

## 2. Abrir un canal (v1 - compatibilidad)
```bash
lncli --network=testnet4 openchannel <pubkey> <local_amt_sat> <push_amt_sat>
```

## 3. Explorar vecinos / nodos cercanos (topología y rutas)
Descarga el grafo conocido (nodos y aristas):
```bash
lncli --network=testnet4 describegraph 
```

Información de un nodo en particular (alias, addresses, channels):
```bash
lncli --network=testnet4 getnodeinfo <pubkey> 
```

Para una gestión más avanzada y amigable de su nodo lightning network, se recomienda descargar el repositorio de la cabina de control:
[https://github.com/btcol/lightning-tools/tree/main](https://github.com/btcol/lightning-tools/tree/main)

*Para una guía conceptual profunda sobre la apertura de canales y la gestión de la liquidez, lea los recursos complementarios `gestion_de_canales.md` y `liquidez_lightning.md`.*

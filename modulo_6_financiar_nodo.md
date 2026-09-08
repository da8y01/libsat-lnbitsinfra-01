# Módulo 6. Financiar el nodo

Ejecute el siguiente comando para generar una dirección nueva de su wallet en LND:
```bash
lncli --network=testnet4 newaddress p2wkh
```

Copie y pegue esa dirección en una fuente de bitcoins (faucet) de la testnet4, por ejemplo:
- https://coinfaucet.eu/en/btc-testnet4/

Espere a recibir el pago. Va a necesitar recoger la mayor cantidad de sats posibles para poder experimentar varios escenarios dentro de la administración de un nodo de lightning network, ya que es necesaria la apertura de varios canales que tengan una buena liquidez local y remota.

*Para una guía conceptual profunda, lea el recurso complementario `faucet.md`.*

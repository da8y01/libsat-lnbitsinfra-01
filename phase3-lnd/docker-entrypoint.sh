#!/bin/bash
set -e

# Asegurar que el directorio de datos exista
mkdir -p /data/lnd

# Si existe un enlace simbólico anterior, removerlo
if [ -L /root/.lnd ]; then
    rm /root/.lnd
fi

# Si no existe configuración, copiar la predefinida
if [ ! -f /data/lnd/lnd.conf ]; then
    cp /root/.lnd/lnd.conf /data/lnd/lnd.conf
fi

# Templar variables sensibles en lnd.conf
sed -i "s/__LND_ALIAS__/${LND_ALIAS}/g" /data/lnd/lnd.conf
sed -i "s/__TOR_PASSWORD__/${TOR_PASSWORD}/g" /data/lnd/lnd.conf
sed -i "s/__BITCOIN_RPC_USER__/${BITCOIN_RPC_USER}/g" /data/lnd/lnd.conf
sed -i "s/__BITCOIN_RPC_PASSWORD__/${BITCOIN_RPC_PASSWORD}/g" /data/lnd/lnd.conf

# Asegurar que /root/.lnd sea el directorio de datos
mkdir -p /root/.lnd

# Wrapper de lncli para simplificar el uso
cat > /usr/local/bin/lnclictl <<EOF
#!/bin/bash
exec lncli --network=testnet4 --rpcserver=localhost:10009 \
    --tlscertpath=/data/lnd/tls.cert \
    --macaroonpath=/data/lnd/data/chain/bitcoin/testnet4/admin.macaroon "\$@"
EOF
chmod +x /usr/local/bin/lnclictl

# Ejecutar LND usando el volumen persistente
exec lnd --configfile=/data/lnd/lnd.conf --lnddir=/data/lnd

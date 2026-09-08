#!/bin/bash
set -e

# Crear el datadir persistente
mkdir -p /data/bitcoin

# Copiar la configuración predeterminada solo la primera vez
if [ ! -f /data/bitcoin/bitcoin.conf ]; then
    cp /root/.bitcoin/bitcoin.conf /data/bitcoin/bitcoin.conf
fi

# Templar variables sensibles en bitcoin.conf
sed -i "s/__BITCOIN_RPC_USER__/${BITCOIN_RPC_USER}/g" /data/bitcoin/bitcoin.conf
sed -i "s/__BITCOIN_RPC_PASSWORD__/${BITCOIN_RPC_PASSWORD}/g" /data/bitcoin/bitcoin.conf

# Configurar localización de bitcoin-cli
cat > /entrypoint-alias.sh <<'EOF'
#!/bin/bash
exec bitcoin-cli -datadir=/data/bitcoin -conf=/data/bitcoin/bitcoin.conf "$@"
EOF
chmod +x /entrypoint-alias.sh
ln -sf /entrypoint-alias.sh /usr/local/bin/btccli

# Crear Bitcoin Core con los argumentos apuntando al datadir persistente
exec bitcoind -datadir=/data/bitcoin -conf=/data/bitcoin/bitcoin.conf
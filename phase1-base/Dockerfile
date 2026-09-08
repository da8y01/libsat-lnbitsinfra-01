FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ARG SSH_PASSWORD=lnbits2026

# Actualizar sistema e instalar dependencias básicas
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    apt-transport-https \
    gnupg \
    wget \
    curl \
    git \
    openssh-server \
    tor \
    torsocks \
    supervisor \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Configurar SSH
RUN mkdir /var/run/sshd && \
    echo "root:${SSH_PASSWORD}" | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Configurar Tor
COPY config/torrc /etc/tor/torrc.template

# Crear directorios necesarios
RUN mkdir -p /var/lib/tor/hidden_service && \
    mkdir -p /var/log/tor && \
    chmod 700 /var/lib/tor/hidden_service && \
    chown -R debian-tor:debian-tor /var/lib/tor && \
    chown -R debian-tor:debian-tor /var/log/tor

# Wrapper de Tor que asegura permisos correctos en cada arranque
# (necesario cuando un volumen Docker monta sobre /var/lib/tor)
RUN printf '%s\n' \
    '#!/bin/bash' \
    'chmod 700 /var/lib/tor/hidden_service' \
    'chown -R debian-tor:debian-tor /var/lib/tor' \
    'mkdir -p /var/log/tor && chown -R debian-tor:debian-tor /var/log/tor' \
    'exec /usr/bin/tor' \
    > /usr/local/bin/tor-wrapper.sh && \
    chmod +x /usr/local/bin/tor-wrapper.sh

# Configurar supervisord para manejar múltiples servicios
RUN mkdir -p /var/log/supervisor && \
    printf '%s\n' \
    '[program:tor]' \
    'command=/usr/local/bin/tor-wrapper.sh' \
    'autostart=true' \
    'autorestart=true' \
    'user=debian-tor' \
    'directory=/tmp' \
    'stdout_logfile=/var/log/tor/stdout.log' \
    'stderr_logfile=/var/log/tor/stderr.log' \
    'priority=100' \
    '' \
    '[program:sshd]' \
    'command=/usr/sbin/sshd -D' \
    'autostart=true' \
    'autorestart=true' \
    'stdout_logfile=/var/log/supervisor/sshd.log' \
    'stderr_logfile=/var/log/supervisor/sshd_err.log' \
    'priority=200' \
    '' \
    '[supervisord]' \
    'nodaemon=true' \
    'logfile=/var/log/supervisor/supervisord.log' \
    'pidfile=/var/run/supervisord.pid' \
    > /etc/supervisor/conf.d/supervisord.conf

# Puertos del servicio
EXPOSE 22 9050 9051

# Entry point: templar torrc y luego iniciar supervisord
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

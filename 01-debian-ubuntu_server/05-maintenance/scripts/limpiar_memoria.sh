#!/bin/bash

# Requiere permisos de superusuario
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta como root o con sudo"
  exit 1
fi

echo "⏳ Sincronizando disco..."
sync

echo "🧹 Limpiando caché de página, dentries e inodes..."
echo 3 > /proc/sys/vm/drop_caches

echo "🧊 Vaciando swap..."
swapoff -a && swapon -a

echo "✅ Memoria caché y swap limpiados."

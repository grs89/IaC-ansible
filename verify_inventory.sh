#!/bin/bash
# Script para verificar el inventario de Ansible

echo "=================================================="
echo "Verificación del Inventario Ansible"
echo "=================================================="
echo

# Verificar que ansible está instalado
if ! command -v ansible &> /dev/null
then
    echo "❌ Ansible no está instalado"
    exit 1
fi

echo "✅ Ansible instalado: $(ansible --version | head -n 1)"
echo

# Verificar conectividad de los hosts
echo "📋 Lista de hosts configurados:"
echo
ansible all --list-hosts
echo

# Test de conectividad
echo "🔍 Verificando conectividad con los servidores..."
echo "   (Esto puede tardar unos segundos)"
echo

if ansible all -m ping 2>/dev/null | grep -q "UNREACHABLE"; then
    echo "⚠️  Algunos servidores son inaccesibles"
    echo "   Verifica la conectividad de red y las credenciales"
    echo
fi

# Mostrar información del inventario
echo "📊 Estructura del inventario por grupos:"
echo
ansible-inventory --graph 2>/dev/null || echo "   No se pudo generar el gráfico"
echo

# Mostrar variables de grupos
echo "🔧 Variables configuradas por grupo:"
echo
if [ -d "group_vars" ]; then
    for file in group_vars/*.yml; do
        if [ -f "$file" ]; then
            echo "   $(basename $file)"
        fi
    done
else
    echo "   No hay archivos de variables de grupo"
fi
echo

echo "=================================================="
echo "Verificación completa"
echo "=================================================="
echo
echo "Comandos útiles:"
echo "  ansible all -m ping                        # Verificar conectividad"
echo "  ansible-inventory --graph                  # Ver estructura completa"
echo "  ansible <nombre_host> -m setup             # Ver información del host"
echo "  ansible-playbook playbook.yml              # Ejecutar playbook"
echo



# 📚 Playbooks de Infraestructura

Esta carpeta contiene los playbooks principales organizados por funcionalidad.

## 🚀 Playbooks Principales

### `site.yml`
Playbook principal que configura la base de todos los servidores.

```bash
ansible-playbook playbooks/site.yml --ask-become-pass
```

**Qué hace:**
- Instala paquetes comunes
- Configura SSH
- Aplica hardening de seguridad

---

### `networking.yml`
Configura IP estáticas en servidores.

```bash
ansible-playbook playbooks/networking.yml --ask-become-pass
```

**Requiere variables:**
- `static_ip`
- `gateway`
- `dns_server`

---

### `install_docker.yml`
Instala Docker Engine en los servidores.

```bash
ansible-playbook playbooks/install_docker.yml
```

**Notas:**
- Funciona en Ubuntu y Debian
- Soporta arquitecturas amd64 y arm64

---

### `install_kubernetes.yml`
Instala Kubernetes (kubelet, kubeadm, kubectl) en el cluster.

```bash
ansible-playbook playbooks/install_kubernetes.yml --ask-become-pass
```

**Qué hace:**
- Instala Docker si no está presente
- Instala componentes de Kubernetes
- Configura el sistema para K8s
- No inicializa el cluster (usa `kubeadm init` manualmente)

---

### `install_ceph.yml`
Instala y configura un cluster Ceph.

```bash
ansible-playbook playbooks/install_ceph.yml --ask-become-pass
```

**Qué hace:**
- Bootstrap de Ceph en el primer nodo
- Agrega nodos adicionales
- Configura OSDs automáticamente

---

### `install_kvm.yml`
Instala KVM/QEMU para virtualización.

```bash
ansible-playbook playbooks/install_kvm.yml --ask-become-pass
```

---

### `deploy_cluster.yml`
Despliega infraestructura completa de Kubernetes.

```bash
ansible-playbook playbooks/deploy_cluster.yml --ask-become-pass
```

**Incluye:**
- Configuración base
- Networking
- Docker
- Kubernetes
- Hardening

---

### `deploy_storage_cluster.yml`
Despliega cluster de almacenamiento Ceph.

```bash
ansible-playbook playbooks/deploy_storage_cluster.yml --ask-become-pass
```

---

## 🔄 Playbooks de Actualización y Mantenimiento

### `upgrade_debian.yml`
Actualiza servidores de Debian 11 (bullseye) a Debian 12 (bookworm).

```bash
ansible-playbook playbooks/upgrade_debian.yml --ask-become-pass
```

**Qué hace:**
- Cambia repositorios de bullseye a bookworm
- Actualiza todos los paquetes (dist-upgrade)
- Reinicia el servidor si es necesario
- Verifica que Apache esté funcionando

**Hosts objetivo:** `debian_servers`

---

### `upgrade_debian_apache.yml`
Similar a `upgrade_debian.yml` pero con verificación inteligente de reinicio.

```bash
ansible-playbook playbooks/upgrade_debian_apache.yml --ask-become-pass
```

**Qué hace:**
- Actualiza paquetes base primero
- Solo reinicia si `/var/run/reboot-required` existe
- Completa dist-upgrade después del reinicio
- Verifica Apache al final

**Hosts objetivo:** `debian_servers`

---

## 📸 Playbooks de Snapshots KVM

### `kvm_create_snapshot.yml`
Crea snapshots automáticos de máquinas virtuales KVM.

```bash
ansible-playbook playbooks/kvm_create_snapshot.yml --ask-become-pass
```

**Qué hace:**
- Crea snapshots atómicos de VMs definidas
- Nombra snapshots con fecha automática
- Útil antes de actualizaciones o cambios críticos

**Variables a configurar:**
```yaml
snapshots:
  - { vm: "Servidor_Web", name: "snap_web_{{ fecha }}" }
  - { vm: "Servidor_BD", name: "snap_bd_{{ fecha }}" }
```

**Hosts objetivo:** `ubuntu_servers` (ajustar según tu inventario)

---

### `kvm_revert_snapshot.yml`
Revierte una VM a un snapshot anterior.

```bash
ansible-playbook playbooks/kvm_revert_snapshot.yml --ask-become-pass
```

**⚠️ Precaución:** Este playbook revierte la VM `Servidor_Web` al snapshot `snap_web`. Edita el archivo para especificar la VM y snapshot correctos.

**Hosts objetivo:** `ubuntu_servers` (ajustar según tu inventario)

---

## 🎯 Uso con Tags

Ejecutar solo ciertas secciones:

```bash
# Solo SSH
ansible-playbook playbooks/site.yml --tags ssh

# Solo Docker
ansible-playbook playbooks/install_docker.yml --tags docker

# Solo Kubernetes
ansible-playbook playbooks/install_kubernetes.yml --tags k8s
```

---

## 📋 Orden de Ejecución Recomendado

Para un despliegue completo:

1. **Configurar base:**
   ```bash
   ansible-playbook playbooks/site.yml --ask-become-pass
   ```

2. **Configurar red:**
   ```bash
   ansible-playbook playbooks/networking.yml --ask-become-pass
   ```

3. **Instalar herramientas:**
   ```bash
   ansible-playbook playbooks/install_docker.yml
   ansible-playbook playbooks/install_kubernetes.yml --ask-become-pass
   ```

4. **O usar todo junto:**
   ```bash
   ansible-playbook playbooks/deploy_cluster.yml --ask-become-pass
   ```

---

## ⚙️ Variables

Las variables por defecto están en los roles. Para override:

```yaml
# Inventario o grupo vars
ssh_port: 2222
docker_users:
  - usuario1
  - usuario2
k8s_version: "1.29"
```

---

## 🔧 Troubleshooting

### Verificar conectividad
```bash
ansible all -m ping
```

### Verificar solo un host
```bash
ansible-playbook playbooks/site.yml --limit k8s-cp
```

### Debug
```bash
ansible-playbook playbooks/site.yml -vvv
```

---

## 📝 Roles Disponibles

- `common`: Paquetes y configuración básica
- `ssh`: Configuración de SSH
- `networking`: Configuración de red
- `docker`: Instalación de Docker
- `kubernetes`: Instalación de Kubernetes
- `ceph`: Instalación de Ceph
- `hardening`: Hardening de seguridad
- `kvm`: Instalación de KVM




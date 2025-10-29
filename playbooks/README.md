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




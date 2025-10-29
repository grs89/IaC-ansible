# 📁 Roles de Ansible

Esta carpeta contiene los roles reutilizables del proyecto.

## 📊 Roles Disponibles

### `common`
Configuración básica para todos los servidores.

**Tareas:**
- Actualiza cache de paquetes
- Instala paquetes esenciales (curl, wget, git, htop, etc.)
- Configura zona horaria UTC
- Configura hostname

**Uso:**
```yaml
roles:
  - common
```

---

### `ssh`
Configuración de SSH.

**Tareas:**
- Habilita autenticación por clave pública
- Configura PermitRootLogin
- Configura puerto SSH
- Deshabilita autenticación por contraseña (opcional)
- Reinicia servicio SSH

**Variables:**
```yaml
ssh_port: 22
ssh_permit_root_login: 'no'
ssh_disable_password_auth: true
```

**Uso:**
```yaml
roles:
  - ssh
  - { role: ssh, ssh_port: 2222 }
```

---

### `networking`
Configuración de red (IP estáticas).

**Tareas:**
- Soporta Debian (interfaces) y Ubuntu (Netplan)
- Configura IP estática, gateway y DNS
- Template adaptado según distribución

**Variables:**
```yaml
static_ip: "192.168.1.100"
gateway: "192.168.1.1"
dns_server: "8.8.8.8"
network_interface: "enp0s1"
```

**Uso:**
```yaml
roles:
  - { role: networking, static_ip: "{{ hostvars[inventory_hostname].static_ip }}" }
```

---

### `docker`
Instalación de Docker Engine.

**Tareas:**
- Detecta arquitectura (amd64/arm64)
- Instala Docker Engine, CLI, containerd
- Instala plugins: buildx, compose
- Habilita servicio Docker
- Agrega usuarios al grupo docker

**Variables:**
```yaml
docker_package_state: present
docker_service_state: started
docker_service_enabled: true
docker_users:
  - user1
  - user2
```

**Uso:**
```yaml
roles:
  - docker
```

---

### `kubernetes`
Instalación de Kubernetes (kubelet, kubeadm, kubectl).

**Tareas:**
- Instala componentes de Kubernetes
- Configura swap y módulos kernel
- Configura sysctl para networking
- Deshabilita swap
- Configura kubelet

**Variables:**
```yaml
k8s_version: "1.28"
static_ip: "192.168.1.100"  # Usado para KUBELET_EXTRA_ARGS
```

**Uso:**
```yaml
roles:
  - { role: kubernetes, k8s_version: "1.29" }
```

**Notas:**
- Requiere Docker instalado previamente
- No inicializa el cluster (usa `kubeadm init` manualmente)
- Ejecutar primero en control plane, luego workers

---

### `ceph`
Instalación de cluster Ceph.

**Tareas:**
- Instala cephadm
- Bootstrap de Ceph en primer nodo
- Agrega nodos adicionales
- Configura OSDs automáticamente

**Variables:**
```yaml
ceph_version: "quincy"
ceph_repo: "https://download.ceph.com/debian-quincy/"
ceph_mon_ip: "{{ hostvars[groups['ceph_servers'][0]].static_ip }}"
```

**Uso:**
```yaml
roles:
  - ceph
```

**Notas:**
- Ejecutar en todos los nodos del cluster
- El bootstrap se hace solo en el primer nodo

---

### `hardening`
Hardening de seguridad.

**Tareas:**
- Configura UFW (firewall)
- Instala Fail2Ban
- Instala Auditd
- Configura Lynis (auditoría)
- Configura políticas de contraseñas (pwquality)
- Configura sysctl para seguridad

**Variables:**
```yaml
ufw_enabled: true
http_enabled: false
https_enabled: false
fail2ban_bantime: 600
fail2ban_maxretry: 5
configure_password_policy: true
```

**Uso:**
```yaml
roles:
  - hardening
```

---

### `kvm`
Instalación de KVM/QEMU.

**Tareas:**
- Instala paquetes KVM/QEMU
- Configura libvirt
- Valida soporte de virtualización
- Habilita servicio libvirtd

**Variables:**
```yaml
kvm_enabled: true
```

**Uso:**
```yaml
roles:
  - kvm
```

---

## 🔧 Crear Nuevo Role

Estructura estándar de un role:

```
roles/
└── nuevo_role/
    ├── defaults/
    │   └── main.yml      # Variables por defecto
    ├── vars/
    │   └── main.yml      # Variables obligatorias
    ├── tasks/
    │   └── main.yml      # Tareas del role
    ├── handlers/
    │   └── main.yml      # Handlers
    ├── templates/        # Templates Jinja2
    ├── files/           # Archivos estáticos
    └── README.md        # Documentación
```

---

## 📝 Mejores Prácticas

1. **Variables por defecto**: Usar `defaults/main.yml`
2. **Documentación**: Incluir README.md en cada role
3. **Tags**: Etiquetar tareas para ejecución selectiva
4. **Test**: Crear tests para cada role
5. **Idempotencia**: Todas las tareas deben ser idempotentes

---

## 🧪 Testing

```bash
# Test un role específico
ansible-playbook tests/test-common.yml

# Test con check mode
ansible-playbook tests/test-common.yml --check
```

---

## 📚 Referencias

- [Ansible Role Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)
- [Galaxy Roles](https://galaxy.ansible.com/docs/)




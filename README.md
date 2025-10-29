# IaC-Ansible - Infraestructura como Código con Ansible

Este proyecto utiliza Ansible para la automatización de tareas de TI y gestión de infraestructura como código.

## Requisitos

- Ansible 2.9 o superior
- Python 3.6 o superior
- SSH configurado con claves para acceso a servidores

## Instalación

1. Clona este repositorio:
    ```bash
    git clone https://github.com/grs89/ansible-1.git
    cd ansible-1
    ```

2. Configura tus claves SSH si aún no lo has hecho:
    ```bash
    ssh-keygen -t rsa -b 4096
    ssh-copy-id usuario@servidor
    ```

3. Para servidores que requieren contraseñas (opcional):
    ```bash
    # Crea un archivo vault para credenciales seguras
    ansible-vault create vault.yml
    ```

## Uso

### Inventario

El proyecto usa un inventario YAML (`inventory.yml`) con múltiples grupos de servidores:

- **ubuntu_servers**: Servidores Ubuntu Server
- **k8s_servers**: Cluster de Kubernetes (control plane + workers)
- **ceph_servers**: Cluster de almacenamiento Ceph
- **debian_servers**: Servidores Debian
- **container_hosts**: Hosts con Docker/Kubernetes

### Ejecutar Playbooks

Para ejecutar un playbook:
```bash
# Ejemplo: Instalar Docker
ansible-playbook playbooks/install_docker.yml

# Con contraseña (si se requiere)
ansible-playbook playbooks/install_docker.yml --ask-become-pass

# Con vault de credenciales
ansible-playbook playbooks/install_docker.yml --ask-vault-pass
```

### Verificar Inventario

```bash
# Listar todos los hosts
ansible all --list-hosts

# Verificar conectividad
ansible all -m ping

# Ver servidores por grupo
ansible-inventory --graph
ansible-inventory --host <nombre_del_servidor>
```

### Variables de Grupo

Las variables específicas por grupo se encuentran en `group_vars/`:
- `all.yml`: Variables globales
- `k8s_servers.yml`: Variables para Kubernetes
- `ceph_servers.yml`: Variables para Ceph
- `ubuntu_servers.yml`: Variables para Ubuntu

## Estructura del Proyecto

```
IaC-ansible/
├── ansible.cfg              # Configuración de Ansible
├── inventory.yml            # Inventario principal (YAML)
├── inventory.ini            # Inventario antiguo (obsoleto)
├── README.md                # Este archivo
├── LICENSE                  # Licencia Apache 2.0
│
├── playbooks/               # Playbooks principales
│   ├── site.yml            # Configuración base
│   ├── networking.yml       # Configurar networking
│   ├── install_docker.yml   # Instalar Docker
│   ├── install_kubernetes.yml
│   ├── install_ceph.yml
│   ├── install_kvm.yml
│   ├── deploy_cluster.yml
│   ├── deploy_storage_cluster.yml
│   └── README.md            # Documentación de playbooks
│
├── roles/                   # Roles reutilizables
│   ├── common/             # Configuración base
│   ├── ssh/                # Configuración SSH
│   ├── networking/         # Configuración de red
│   ├── docker/             # Instalación Docker
│   ├── kubernetes/         # Instalación Kubernetes
│   ├── ceph/               # Instalación Ceph
│   ├── hardening/          # Hardening seguridad
│   └── kvm/                # Instalación KVM
│
├── group_vars/             # Variables por grupo
│   ├── all.yml
│   ├── k8s_servers.yml
│   ├── ceph_servers.yml
│   └── ubuntu_servers.yml
│
└── old/                     # Playbooks antiguos (histórico)
    ├── 01-debian-ubuntu_server/
    ├── 02-debian/
    ├── 02-ubuntu-server/
    └── inventory.yml
```


## Seguridad

⚠️ **Importante**: Este proyecto NO almacena credenciales en texto plano.

Para servidores que requieren contraseñas:

1. Usa Ansible Vault para encriptar credenciales:
   ```bash
   ansible-vault create vault.yml
   ```

2. O ejecuta playbooks con prompts de contraseña:
   ```bash
   ansible-playbook playbook.yml --ask-become-pass
   ```

3. Nunca subas archivos con credenciales al repositorio.

## Ejemplos de Uso

### Configurar red estática en servidores Kubernetes
```bash
ansible-playbook old/02-ubuntu-server/02-networking/set_static_ip.yml --ask-become-pass
```

### Instalar Docker en servidor Ubuntu
```bash
ansible-playbook playbooks/install_docker.yml
```

### Configurar toda la base de servidores
```bash
ansible-playbook playbooks/site.yml --ask-become-pass
```

### Desplegar cluster completo (K8s + Base)
```bash
ansible-playbook playbooks/deploy_cluster.yml --ask-become-pass
```

### Crear cluster Kubernetes
```bash
ansible-playbook old/02-ubuntu-server/03-tools/k8s/install_k8s.yml --ask-become-pass
```

## Mantenimiento

- El directorio `old/` contiene playbooks históricos que pueden requerir adaptaciones
- Los roles en `playbooks/roles/` son los mantenidos activamente
- Revisa las variables en `group_vars/` antes de ejecutar playbooks

## Licencia

Este proyecto está licenciado bajo la Apache-2.0 License. Consulta el archivo `LICENSE` para más detalles.

## Recursos Adicionales

- [Documentación de Ansible](https://docs.ansible.com/)
- [Guía de mejores prácticas de Ansible](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html)
- [Repositorio de ejemplos de Ansible](https://github.com/ansible/ansible-examples)
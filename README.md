# GNS3 Network Labs

This is a repository of network topologies built in **GNS3** and automated with **Ansible**. Each topology focuses on different networking concepts, and the goal is to preserve all the configurations for future reference and reuse.

---

## Project Structure

Each folder contains the specific topology, Ansible playbooks, topology diagrams and explanations.

- **[Layer 3 Inter-VLAN Lab](./Layer3_InterVLAN)**: A hierarchical network consisting of SVIs, Inter-VLAN routing and DHCP/DNS services.
<!-- - **[Link Redundant OSPF Lab](./OSPF_Redundant_Lab)**: A network with dynamic routing and link redundancy between Edge and Core devices.
- **[Hierarchical Spine-Leaf OSPF Lab](./OSPF_Redundant_Lab)**: A network running OSPF with complete redundancy at the Core. Also includes Stub areas. -->

---

## Global Prerequisites & Setup

### 1. Cisco Image Binaries

The Cisco IOSv and IOSvL2 image files required for these labs are located in the `/images` folder at the root of this repository. Add them as Qemu VMs in the GNS3 Preferences.

### 2. Management Bridge (`br-mgmt`)

All topologies utilize an **Out-of-Band (OOB) Management** network.

- Ensure the GNS3 host has a bridge interface named `br-mgmt` with ip `172.31.255.1`.
- This bridge provides connectivity between the Ansible control node (local machine) and the GNS3 nodes.

### 3. Bootstrap Configurations

Every device requires an initial configuration to enable SSH communication via the Management network. Specific bootstrap commands (IP assignment, local user, and `line vty` settings) are provided within each topology folder.

### 4. Docker Environment

Alpine linux images running on Docker containers are used whenever a linux environment is needed. A base image for the same can be made from the Dockerfile provided.

```
docker pull alpine:latest
docker build --no-cache -t custom-alpine .
```

### 5. SSH Configuration (Legacy Support)

Cisco IOSv images utilize legacy cryptographic algorithms (e.g., `ssh-rsa`, `diffie-hellman-group14-sha1`) that are disabled by default on modern OpenSSH clients.

To allow Ansible to connect to the lab nodes, add the following configuration to your `~/.ssh/config` file:

```ssh
# GNS3 Lab Management Network
Host 172.31.255.*
    KexAlgorithms +diffie-hellman-group14-sha1
    HostKeyAlgorithms +ssh-rsa
    PubkeyAcceptedAlgorithms +ssh-rsa
    MACs +hmac-sha1,hmac-sha1-96
```

# Bootstrap Guide

This file contains the **initial bootstrap configuration** required to bring all devices online.

This step ensures:

- Every device is reachable via SSH
- Automation tools can connect
- Recovery is possible even if the data plane is broken

---

## Management Network

Subnet used:

```
172.31.255.0/24
```

<center>

| Device | Role            | Management IP |
| ------ | --------------- | ------------- |
| R1     | Edge Router     | 172.31.255.10 |
| Core   | Core Switch     | 172.31.255.11 |
| Access | Access Switch   | 172.31.255.12 |
| Linux  | DHCP/DNS Server | 172.31.255.13 |

</center>

All management interfaces connect to the same **management switch**.

---

# R1 – Bootstrap

```text
enable
conf t
hostname R1

interface GigabitEthernet0/0
 description MANAGEMENT
 ip address 172.31.255.10 255.255.255.0
 no shutdown
exit

username admin privilege 15 secret cisco
ip domain-name lab.local
crypto key generate rsa general-keys modulus 2048
ip ssh version 2

line vty 0 15
 login local
 transport input ssh
exit

end
write memory
```

---

# Core Switch – Bootstrap

```text
enable
conf t
hostname Core

interface GigabitEthernet0/0
 description MANAGEMENT
 no switchport
 ip address 172.31.255.11 255.255.255.0
 no shutdown
exit

username admin privilege 15 secret cisco
ip domain-name lab.local
crypto key generate rsa general-keys modulus 2048
ip ssh version 2

line vty 0 15
 login local
 transport input ssh
exit

end
write memory
```

---

# Access Switch – Bootstrap

```text
enable
conf t
hostname Access

interface GigabitEthernet0/0
 description MANAGEMENT
 no switchport
 ip address 172.31.255.12 255.255.255.0
 no shutdown
exit

username admin privilege 15 secret cisco
ip domain-name lab.local
crypto key generate rsa general-keys modulus 2048
ip ssh version 2

line vty 0 15
 login local
 transport input ssh
exit

end
write memory
```

---

# Linux OOB Host

Edit network configuration:

```
sudo nano /etc/network/interfaces
```

```
auto eth0
iface eth0 inet static
    address 172.31.255.13
    netmask 255.255.255.0
```

Apply:

```
rc-service networking restart
```

---

# Validation

From the Linux host:

```
ping 172.31.255.10
ping 172.31.255.11
ping 172.31.255.12
ping 172.31.255.13
```

Test SSH:

```
ssh admin@172.31.255.10
ssh admin@172.31.255.11
ssh admin@172.31.255.12
ssh root@172.31.255.13
```

If all four succeed, the management plane is operational and automation can begin.

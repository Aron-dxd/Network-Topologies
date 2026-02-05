FROM alpine:latest

RUN apk add --no-cache openssh nano openrc bash python3

RUN mkdir -p /run/openrc && touch /run/openrc/softlevel
RUN rc-update add sshd default

RUN ssh-keygen -A && \
    echo "root:root" | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN printf "#!/bin/bash\nopenrc default\nsleep 1\nexec /bin/bash\n" > /entrypoint.sh && \
    chmod +x /entrypoint.sh

RUN rc-update add networking default

VOLUME ["/root", "/etc", "/var", "/home"]

ENTRYPOINT ["/entrypoint.sh"]

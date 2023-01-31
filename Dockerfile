FROM debian:bullseye

ARG user=debian
ARG group=debian
ARG uid=1000
ARG gid=1000
ARG AGENT_HOME=/home/${user}

ENV AGENT_HOME=${AGENT_HOME}
RUN groupadd -g ${gid} ${group} \
    && useradd -d "${AGENT_HOME}" -u "${uid}" -g "${gid}" -m -s /bin/bash "${user}" \
    && mkdir -p "${AGENT_HOME}/.ssh/" \
    && chown -R "${uid}":"${gid}" "${AGENT_HOME}"

RUN sed -i -E 's/(deb|security).debian.org/mirrors.tencent.com/g' /etc/apt/sources.list
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
       git-lfs \
       less \
       netcat-traditional \
       openssh-server \
       patch \
    && rm -rf /var/lib/apt/lists/*

# setup SSH server
RUN sed -i /etc/ssh/sshd_config \
        -e 's/#PermitRootLogin.*/PermitRootLogin no/' \
        -e 's/#RSAAuthentication.*/RSAAuthentication yes/'  \
        -e 's/#PasswordAuthentication.*/PasswordAuthentication no/' \
        -e 's/#SyslogFacility.*/SyslogFacility AUTH/' \
        -e 's/#LogLevel.*/LogLevel INFO/' && \
    mkdir /var/run/sshd

ENV LANG='C.UTF-8' LC_ALL='C.UTF-8'

COPY setup-sshd /usr/local/bin/setup-sshd

EXPOSE 22

ENTRYPOINT ["setup-sshd"]

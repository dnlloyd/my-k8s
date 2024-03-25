FROM ubuntu as build

# Core
RUN apt update && apt install -y curl wget gnupg unzip lsb-release

# Hashicorp
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

# FROM ubuntu as install

# COPY --from=build /etc/apt/sources.list.d/hashicorp.list /etc/apt/sources.list.d/hashicorp.list
# COPY --from=build /usr/share/keyrings/hashicorp-archive-keyring.gpg /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Packages
RUN apt update && apt install -y \
  vault \
  terraform

RUN apt update && apt install -y \
  netcat \
  traceroute \
  dnsutils \
  iputils-ping \
  vim \
  tree \
  net-tools \
  iproute2 \
  openssh-client \
  openssl

RUN apt install -y \
  software-properties-common

RUN apt install -y \
  postgresql-client \
  sqlite3

# Kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

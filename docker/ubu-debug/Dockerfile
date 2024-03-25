FROM ubuntu

# Packages
RUN apt update && apt install -y \
  curl \
  netcat \
  traceroute \
  dnsutils \
  iputils-ping \
  vim \
  tree \
  net-tools \
  iproute2 \
  openssh-client \
  openssl \
  postgresql-client \
  sqlite3

# Kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

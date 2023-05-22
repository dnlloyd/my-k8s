FROM ubuntu

# Vault
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

# Terraform
# RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
#   gpg --dearmor | \
#   sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

RUN apt update && apt install -y \
  curl \
  netcat \
  traceroute \
  dnsutils \
  iputils-ping \
  wget \
  vim \
  unzip \
  tree \
  net-tools \
  iproute2 \
  vault \
  openssh-client \
  openssl \
  gnupg \
  software-properties-common \
  terraform \
  sqlite3

# Kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

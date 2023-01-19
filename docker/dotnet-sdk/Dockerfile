ARG BASELINE_TAG=0.1.0

FROM 458891109543.dkr.ecr.us-east-1.amazonaws.com/base-alpine:$BASELINE_TAG

ARG DOTNET_VERSION=6.0
ARG TAG=0.1.0

# Pre-requisits
# https://docs.microsoft.com/en-us/dotnet/core/install/linux-alpine#dependencies
RUN apk add bash icu-libs krb5-libs libgcc libintl libssl1.1 libstdc++ zlib

# https://github.com/dotnet/docs/issues/33101
RUN apk add libgdiplus --repository http://dl-cdn.alpinelinux.org/alpine/latest-stable/community

# Getting dotnet command available
RUN mkdir -p /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet 

# https://docs.microsoft.com/en-us/dotnet/core/install/linux-scripted-manual#scripted-install
# https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script
RUN wget https://dot.net/v1/dotnet-install.sh 
RUN chmod +x dotnet-install.sh

# Install .NET SDK
RUN ./dotnet-install.sh -c $DOTNET_VERSION --install-dir /usr/share/dotnet
RUN dotnet --info

CMD "/bin/bash"


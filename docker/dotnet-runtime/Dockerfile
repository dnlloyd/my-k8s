
ARG BASELINE_VERSION=os-alpine3.15
ARG BASELINE_TAG=0.1.0

FROM 458891109543.dkr.ecr.us-east-1.amazonaws.com/base-alpine:$BASELINE_TAG

ARG DOTNET_VERSION=6.0
ARG TAG=latest

# Pre-requisits
# https://docs.microsoft.com/en-us/dotnet/core/install/linux-alpine
# https://docs.microsoft.com/en-us/dotnet/core/install/linux-alpine#dependencies
RUN apk add bash icu-libs krb5-libs libgcc libintl libssl1.1 libstdc++ zlib

# if the .NET app requires the System.Drawing.Common assembly
# https://github.com/dotnet/docs/issues/33101
RUN apk add libgdiplus --repository http://dl-cdn.alpinelinux.org/alpine/latest-stable/community

# Getting dotnet command available
RUN mkdir -p /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet 

# https://docs.microsoft.com/en-us/dotnet/core/install/linux-scripted-manual#scripted-install
# https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script
RUN wget https://dot.net/v1/dotnet-install.sh 
RUN chmod +x dotnet-install.sh

# Install .NET Core
RUN ./dotnet-install.sh -c $DOTNET_VERSION --runtime dotnet --install-dir /usr/share/dotnet
# RUN dotnet --info
    
# Microsoft.EntityFrameworkCore.SqlServer Version 3.0.0
# Microsoft.Data.SqlClient version: 1.0.19249.1
# Target framework: (.NET Core 3.0, 3.1)
# Operating system: Docker Alpine

# Fix based on https://github.com/dotnet/SqlClient/issues/220
RUN apk add --no-cache icu-libs
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

CMD "/bin/bash"

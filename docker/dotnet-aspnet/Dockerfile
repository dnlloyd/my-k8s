ARG DOTNET_VERSION=6.0
ARG RUNTIME_TAG=0.1.0
ARG DOTNET_TAG=0.1.0

#BLK FROM ghcr.io/buildinglink/dotnet-runtime:$DOTNET_TAG
FROM 458891109543.dkr.ecr.us-east-1.amazonaws.com/dotnet-runtime:$DOTNET_TAG

ARG DOTNET_VERSION
ARG TAG=latest

#BLK LABEL org.opencontainers.image.source https://github.com/BuildingLink/Containers/tree/master/baseline/dotnet/aspnet
#BLK LABEL org.opencontainers.image.registry ghcr.io/buildinglink/baseline/dotnet/aspnet-$DOTNET_VERSION:$TAG

# Install ASP.NET Core
RUN ./dotnet-install.sh -c $DOTNET_VERSION --runtime aspnetcore --install-dir /usr/share/dotnet

CMD "/bin/bash"


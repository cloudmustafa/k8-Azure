#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY SimpleAPI.csproj ./
RUN dotnet restore "./SimpleAPI.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "SimpleAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SimpleAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SimpleAPI.dll"]

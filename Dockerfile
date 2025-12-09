# Base runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app

# Render sẽ inject biến PORT, nên ta listen vào biến này
ENV ASPNETCORE_URLS=http://0.0.0.0:$PORT

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

COPY ["CmsAppTikTok.csproj", "./"]
RUN dotnet restore "CmsAppTikTok.csproj"

COPY . .
RUN dotnet build "CmsAppTikTok.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publish stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "CmsAppTikTok.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "CmsAppTikTok.dll"]
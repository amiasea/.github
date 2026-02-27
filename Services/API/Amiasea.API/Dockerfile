# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy project files
COPY ["Services/API/Amiasea.API/Amiasea.API.csproj", "Services/API/Amiasea.API/"]
COPY ["Services/Data/Amiasea.Data.Access/Amiasea.Data.Access.csproj", "Services/Data/Amiasea.Data.Access/"]
COPY ["Services/Data/Amiasea.Data.Entity/Amiasea.Data.Entity.csproj", "Services/Data/Amiasea.Data.Entity/"]
COPY ["Services/Data/Amiasea.Data.Service/Amiasea.Data.Service.csproj", "Services/Data/Amiasea.Data.Service/"]

# Restore dependencies
RUN dotnet restore "Services/API/Amiasea.API/Amiasea.API.csproj"

# Copy remaining source code
COPY . .

# Build
RUN dotnet build "Services/API/Amiasea.API/Amiasea.API.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "Services/API/Amiasea.API/Amiasea.API.csproj" -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

EXPOSE 80
ENTRYPOINT ["dotnet", "Amiasea.API.dll"]

# Utiliza la imagen oficial de .NET SDK para compilar la aplicación
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copia los archivos del proyecto y restaura las dependencias
COPY *.csproj ./

RUN dotnet restore

COPY . ./
# Publica la aplicación en modo de producción
RUN dotnet publish -c Release -o out

# Utiliza una imagen ligera de .NET para ejecutar la aplicación
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime-env
WORKDIR /app
COPY --from=build-env /app/out .

# Expone el puerto en el que la aplicación escucha
EXPOSE 8080

# Comando para iniciar la aplicación cuando el contenedor se ejecuta
ENTRYPOINT ["dotnet", "BlazorApp.dll"]
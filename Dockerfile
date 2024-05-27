# Use the official ASP.NET Core runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Use the official ASP.NET Core build image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["HRFusion.csproj", "./"]
RUN dotnet restore "./HRFusion.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "HRFusion.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "HRFusion.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HRFusion.dll"]

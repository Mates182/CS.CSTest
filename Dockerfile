FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["CSharpTest/CSharpTest.csproj", "CSharpTest/"]
RUN dotnet restore "CSharpTest/CSharpTest.csproj"
COPY . .
WORKDIR "/src/CSharpTest"
RUN dotnet build "CSharpTest.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "CSharpTest.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CSharpTest.dll"]

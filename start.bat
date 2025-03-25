@echo off
rem Spostarsi nella cartella API (dove si trova il codice backend)
cd /d "%~dp0API"

rem Controlla se Docker è installato
where docker >nul 2>&1
if errorlevel 1 (
    echo Error: Docker is not installed or not in PATH
    echo Please install Docker from https://docs.docker.com/get-docker/
    pause
    exit /b 1
)

rem Controlla se Docker Compose è disponibile
set "DOCKER_COMPOSE_CMD="
where docker-compose >nul 2>&1
if not errorlevel 1 (
    set "DOCKER_COMPOSE_CMD=docker-compose"
) else (
    docker compose version >nul 2>&1
    if not errorlevel 1 (
        set "DOCKER_COMPOSE_CMD=docker compose"
    ) else (
        echo Error: Neither docker-compose nor docker compose plugin is available
        echo Please install Docker Compose from https://docs.docker.com/compose/install/
        pause
        exit /b 1
    )
)

echo Using Docker Compose command: %DOCKER_COMPOSE_CMD%

rem Controlla se il file .env esiste, altrimenti crealo
if not exist ".env" (
    echo Creating .env file...
    (
        echo # Database
        echo DATABASE_URL=./database.db
        echo.
        echo # Google OAuth
        echo CLIENT_ID=114549057021-1regresnv2eue5ig42h76idmn34rh38s.apps.googleusercontent.com
        echo.
        echo # Session Secret
        echo SESSION_SECRET=TripsphereEdoCorti
        echo.
        echo # Porta del server
        echo PORT=3000
        echo.
        echo # Ambiente (development, production, etc.)
        echo NODE_ENV=development
    ) > .env
    echo .env file created successfully.
) else (
    echo .env file already exists.
)

rem Build e start dei container
echo Building and starting Docker containers...
%DOCKER_COMPOSE_CMD% up --build -d

rem Attendi l'avvio dei servizi
echo Waiting for services to start...
timeout /t 10 >nul

rem Controlla se i servizi sono attivi
%DOCKER_COMPOSE_CMD% ps | findstr /C:"Up" >nul
if %errorlevel%==0 (
    echo Site available at: http://localhost:3000
    echo.
    echo Press Enter to continue...
    pause
) else (
    echo Error: Services failed to start properly
    %DOCKER_COMPOSE_CMD% logs
    pause
    exit /b 1
)

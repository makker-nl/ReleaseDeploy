@echo off
rem ###################################################################################################
rem  deployAll
rem  Script to deploy OSB, SOA or BPM
rem 
rem  author: Martien van den Akker
rem  (C) october 2017
rem  Darwin-IT Professionals
rem ###################################################################################################
rem @call ..\Generic\fmw_env.bat
@set DEPLOYMENT_ENVIRONMENT=%1
@set ENV_PROP_DIR=%2
@set ENV_PROP_FILE=%ENV_PROP_DIR%\%DEPLOYMENT_ENVIRONMENT%.properties
rem
rem check if FMW_HOME is set
rem
if "%FMW_HOME%"=="" (
  echo [ERROR] FMW_HOME not set.
  echo set FMW_HOME environment  
  GOTO USAGE
)
REM
REM Check if environment is specified on comamnd line
REM 
IF "%DEPLOYMENT_ENVIRONMENT%"=="" (
  ECHO [ERROR] The deployment environment is not specified.
  GOTO USAGE
) ELSE (
  ECHO [OK] The deployment environment is specified: %DEPLOYMENT_ENVIRONMENT%.
)

IF "%ENV_PROP_DIR%"=="" (
  ECHO [ERROR] The directory with 'properties' file is not specified.
  GOTO USAGE
) ELSE (
  ECHO [OK] The directory with 'properties' file is specified: %ENV_PROP_DIR%.
)

REM
REM Check if property directory exists
REM
IF NOT EXIST %ENV_PROP_DIR% (
  ECHO [ERROR] The deployment environment configuration directory %ENV_PROP_DIR% does not exist
  GOTO HELP
) ELSE (
  ECHO [OK] The deployment environment configuration directory %ENV_PROP_DIR% exists
)

REM
REM Check if property file itself exists
REM 

IF NOT EXIST %ENV_PROP_FILE% (
  ECHO [ERROR] The deployment environment  environment configuration file %ENV_PROP_FILE% does not exist
  GOTO HELP
) ELSE (
  ECHO [OK] The deployment environment environment configuration file %ENV_PROP_FILE% exists
)

REM
REM Check if property file contains proprties matching environment
REM 

FIND /c "server" %ENV_PROP_FILE% >NUL
IF %ERRORLEVEL% EQU 1 (
  ECHO [ERROR] Properties for %DEPLOYMENT_ENVIRONMENT% environment not found
  GOTO HELP
) else (
  ECHO [OK] Properties for %DEPLOYMENT_ENVIRONMENT% environment found
)
ECHO.
ECHO Start ant deploy
ECHO.
ant -f build.xml deployAll  -Denv.prop.dir=%ENV_PROP_DIR% -Ddeployment.plan.environment=%DEPLOYMENT_ENVIRONMENT%

:USAGE
ECHO.
ECHO [INFO] Run script %0.bat ^<osoa^|obpm^|tsoa^|tbpm^> ^<Environment property location^>
ECHO [INFO] %0 obpm ..\Generic
GOTO END

:HELP
ECHO.
ECHO [INFO]Create script %ENV_PROP_FILE% 
ECHO example content (see for particular content documentation)
ECHO # Deployment properties for O-BPM-1 Environment.
ECHO #deploy.user=adminUser
ECHO #deploy.password=adminUserPassword
ECHO deploy.overwrite=true
ECHO deploy.forceDefault=true
ECHO deploy.keepInstancesOnRedeploy=true
ECHO deploy.server.type=bpm
ECHO deploy.server=o-bpm-1-bpm-1-vhn.ont.org.darwin-it.local
ECHO deploy.port=8001
ECHO deploy.serverURL=http\://${deploy.server}\:${deploy.port}
ECHO deploy.admin.server=o-bpm-1-admin-vhn.ont.org.darwin-it.local
ECHO deploy.admin.port=7001
ECHO deploy.adminServerURL=t3\://${deploy.admin.server}\:${deploy.admin.port}
ECHO # Config plan replacement properties
ECHO soasuite.URL=${deploy.serverURL}
ECHO soaserver.endpoint=${deploy.server}\:${deploy.port}
ECHO bpm.URL=o-bpm-1.ont.org.darwin-it.local
ECHO soa.URL=o-soa-1.ont.org.darwin-it.local
ECHO osb.URL=o-osb-1.ont.org.darwin-it.local
:END

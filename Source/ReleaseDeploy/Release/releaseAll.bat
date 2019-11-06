@echo off
@echo Start releasing...
SETLOCAL
rem @call ..\Generic\fmw_env.bat
rem
rem Check if release name, number and location are passed
rem
rem Set Release Name
if "%1"=="" (
  echo [ERROR] Release Name not specified
  echo %0 DOE 1.0.0 ../../Releases
  echo Exiting
  goto END
)
@set RELEASE_NAME=%1

rem set RELEASE_NR
if "%2"=="" (
  echo [ERROR] Release number not specified
  echo %0 DOE 1.0.0 ../../Releases
  echo Exiting
  goto END
)
@set RELEASE_NR=%2

rem set RELEASE_LOC
if "%3"=="" (
  echo [ERROR] Release folder not specified
  echo %0 DOE 1.0.0 ../../Releases
  echo Exiting
  goto END
)
@set RELEASE_DIR=%3

rem
rem check if FMW_HOME is set
rem
if "%FMW_HOME%"=="" (
  echo [ERROR] FMW_HOME not set.
  echo set FMW_HOME environment 
  echo Exiting ..
  goto END
)

rem
rem check if java exists
rem
if not exist "%JAVA_HOME%"\bin\java.exe (
  echo [ERROR] java not found in %JAVA_HOME%
  echo @set JAVA_HOME environment 
  echo Exiting ..
  goto END
)

rem
rem check if ant exists
rem
if not exist %ANT_HOME%\bin\ant (
  echo [ERROR] ant not found in %ANT_HOME%\bin
  echo Exiting ..
  goto END
)


echo FMW_HOME=%FMW_HOME%
set OSB_HOME=%FMW_HOME%\osb
echo JAVA_HOME=%JAVA_HOME%
echo ANT_HOME=%ANT_HOME%
set OSB_OPTS=
set OSB_OPTS= %OSB_OPTS% -Dweblogic.home="%WL_HOME%/server"
set OSB_OPTS= %OSB_OPTS% -Dosb.home="%OSB_HOME%"
rem set OSB_OPTS= %OSB_OPTS% -Djava.util.logging.config.class=oracle.core.ojdl.logging.LoggingConfiguration
rem set OSB_OPTS= %OSB_OPTS% -Doracle.core.ojdl.logging.config.file="%CONFIGJAR_HOME%/logging.xml"

set JAVA_OPTS=%JAVA_OPTS% %OSB_OPTS%
set ANT_OPTS=%ANT_OPTS% %OSB_OPTS%
set ANT_PARS=%ANT_PARS%

echo ANT_OPTS: %ANT_OPTS%
echo ANT_PARS: %ANT_PARS%
echo Call ant for project %RELEASE_NAME% and release %RELEASE_NR%
ant -f build.xml -DreleaseName=%RELEASE_NAME% -Drelease=%RELEASE_NR%  -DreleaseDir=%RELEASE_DIR%  %ANT_PARS%
:END
ENDLOCAL
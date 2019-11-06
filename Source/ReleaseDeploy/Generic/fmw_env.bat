@echo off
@echo Set FMW12c Environment
rem @set FMW_HOME=c:\Oracle\Middleware\Oracle_Home
@set FMW_HOME=c:\Oracle\JDeveloper\12210_BPMQS
@set ORACLE_HOME=%FMW_HOME%
@echo FMW Home set to: %FMW_HOME%
@echo Oracle Home set to: %ORACLE_HOME%
@echo JAVA Home set to: %JAVA_HOME%
@call %FMW_HOME%\wlserver\server\bin\setWLSEnv.cmd
set PATH=%WL_HOME%\common\bin;%WL_HOME%\server\bin;%PATH% 
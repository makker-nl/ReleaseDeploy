@echo off
@echo Set FMW12c Environment
@rem @set FMW_HOME=c:\Oracle\Middleware\Oracle_Home
@set FMW_HOME=c:\Oracle\JDeveloper\12210_BPMQS
@set OSB_HOME=${FMW_HOME}\osb
@set ORACLE_HOME=%FMW_HOME%
@echo FMW Home set to: %FMW_HOME%
@echo Oracle Home set to: %ORACLE_HOME%
@echo JAVA Home set to: %JAVA_HOME%
@call %FMW_HOME%\oracle_common\common\bin\setWLSEnv.cmd
set PATH=%FMW_HOME%\oracle_common\common\bin;%WL_HOME%\server\bin;%PATH%
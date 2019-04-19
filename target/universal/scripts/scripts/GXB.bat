@REM FLG launcher script
@REM
@REM Environment:
@REM JAVA_HOME - location of a JDK home dir (optional if java on path)
@REM CFG_OPTS  - JVM options (optional)
@REM Configuration:
@REM FLG_config.txt found in the FLG_HOME.
@setlocal enabledelayedexpansion

@echo off


if "%FLG_HOME%"=="" (
  set "APP_HOME=%~dp0\\.."

  rem Also set the old env name for backwards compatibility
  set "FLG_HOME=%~dp0\\.."
) else (
  set "APP_HOME=%FLG_HOME%"
)

set "APP_LIB_DIR=%APP_HOME%\lib\"

rem Detect if we were double clicked, although theoretically A user could
rem manually run cmd /c
for %%x in (!cmdcmdline!) do if %%~x==/c set DOUBLECLICKED=1

rem FIRST we load the config file of extra options.
set "CFG_FILE=%APP_HOME%\FLG_config.txt"
set CFG_OPTS=
call :parse_config "%CFG_FILE%" CFG_OPTS

rem We use the value of the JAVACMD environment variable if defined
set _JAVACMD=%JAVACMD%

if "%_JAVACMD%"=="" (
  if not "%JAVA_HOME%"=="" (
    if exist "%JAVA_HOME%\bin\java.exe" set "_JAVACMD=%JAVA_HOME%\bin\java.exe"
  )
)

if "%_JAVACMD%"=="" set _JAVACMD=java

rem Detect if this java is ok to use.
for /F %%j in ('"%_JAVACMD%" -version  2^>^&1') do (
  if %%~j==java set JAVAINSTALLED=1
  if %%~j==openjdk set JAVAINSTALLED=1
)

rem BAT has no logical or, so we do it OLD SCHOOL! Oppan Redmond Style
set JAVAOK=true
if not defined JAVAINSTALLED set JAVAOK=false

if "%JAVAOK%"=="false" (
  echo.
  echo A Java JDK is not installed or can't be found.
  if not "%JAVA_HOME%"=="" (
    echo JAVA_HOME = "%JAVA_HOME%"
  )
  echo.
  echo Please go to
  echo   http://www.oracle.com/technetwork/java/javase/downloads/index.html
  echo and download a valid Java JDK and install before running FLG.
  echo.
  echo If you think this message is in error, please check
  echo your environment variables to see if "java.exe" and "javac.exe" are
  echo available via JAVA_HOME or PATH.
  echo.
  if defined DOUBLECLICKED pause
  exit /B 1
)


rem We use the value of the JAVA_OPTS environment variable if defined, rather than the config.
set _JAVA_OPTS=%JAVA_OPTS%
if "!_JAVA_OPTS!"=="" set _JAVA_OPTS=!CFG_OPTS!

rem We keep in _JAVA_PARAMS all -J-prefixed and -D-prefixed arguments
rem "-J" is stripped, "-D" is left as is, and everything is appended to JAVA_OPTS
set _JAVA_PARAMS=
set _APP_ARGS=

set "APP_CLASSPATH=%APP_LIB_DIR%\com.wavesplatform.FLG-5f42f519a9cd92e6f9c094810963c67180fd5b01-DIRTY.jar;%APP_LIB_DIR%\com.wavesplatform.lang-1.0.0.jar;%APP_LIB_DIR%\org.scala-lang.scala-library-2.12.7.jar;%APP_LIB_DIR%\org.typelevel.cats-core_2.12-1.1.0.jar;%APP_LIB_DIR%\org.typelevel.cats-macros_2.12-1.1.0.jar;%APP_LIB_DIR%\org.typelevel.cats-kernel_2.12-1.1.0.jar;%APP_LIB_DIR%\org.typelevel.cats-mtl-core_2.12-0.3.0.jar;%APP_LIB_DIR%\com.github.mpilquist.simulacrum_2.12-0.12.0.jar;%APP_LIB_DIR%\org.typelevel.macro-compat_2.12-1.1.1.jar;%APP_LIB_DIR%\org.typelevel.machinist_2.12-0.6.4.jar;%APP_LIB_DIR%\org.scalacheck.scalacheck_2.12-1.14.0.jar;%APP_LIB_DIR%\org.scala-sbt.test-interface-1.0.jar;%APP_LIB_DIR%\org.scorexfoundation.scrypto_2.12-2.0.4.jar;%APP_LIB_DIR%\org.rudogma.supertagged_2.12-1.4.jar;%APP_LIB_DIR%\org.whispersystems.curve25519-java-0.4.1.jar;%APP_LIB_DIR%\org.bouncycastle.bcprov-jdk15on-1.58.jar;%APP_LIB_DIR%\org.scalatest.scalatest_2.12-3.0.5.jar;%APP_LIB_DIR%\org.scalactic.scalactic_2.12-3.0.5.jar;%APP_LIB_DIR%\org.scala-lang.modules.scala-xml_2.12-1.0.6.jar;%APP_LIB_DIR%\io.monix.monix_2.12-3.0.0-RC1.jar;%APP_LIB_DIR%\io.monix.monix-execution_2.12-3.0.0-RC1.jar;%APP_LIB_DIR%\org.reactivestreams.reactive-streams-1.0.2.jar;%APP_LIB_DIR%\io.monix.monix-eval_2.12-3.0.0-RC1.jar;%APP_LIB_DIR%\io.monix.monix-tail_2.12-3.0.0-RC1.jar;%APP_LIB_DIR%\io.monix.monix-reactive_2.12-3.0.0-RC1.jar;%APP_LIB_DIR%\org.jctools.jctools-core-2.1.1.jar;%APP_LIB_DIR%\io.monix.monix-java_2.12-3.0.0-RC1.jar;%APP_LIB_DIR%\org.typelevel.cats-effect_2.12-0.10.1.jar;%APP_LIB_DIR%\org.scodec.scodec-core_2.12-1.10.3.jar;%APP_LIB_DIR%\org.scodec.scodec-bits_2.12-1.1.2.jar;%APP_LIB_DIR%\com.chuusai.shapeless_2.12-2.3.3.jar;%APP_LIB_DIR%\com.lihaoyi.fastparse_2.12-1.0.0.jar;%APP_LIB_DIR%\com.lihaoyi.fastparse-utils_2.12-1.0.0.jar;%APP_LIB_DIR%\com.lihaoyi.sourcecode_2.12-0.1.4.jar;%APP_LIB_DIR%\org.bykn.fastparse-cats-core_2.12-0.1.0.jar;%APP_LIB_DIR%\org.typelevel.cats-laws_2.12-1.1.0.jar;%APP_LIB_DIR%\org.typelevel.cats-kernel-laws_2.12-1.1.0.jar;%APP_LIB_DIR%\org.typelevel.discipline_2.12-0.8.jar;%APP_LIB_DIR%\org.typelevel.catalysts-platform_2.12-0.0.5.jar;%APP_LIB_DIR%\org.typelevel.catalysts-macros_2.12-0.0.5.jar;%APP_LIB_DIR%\org.typelevel.cats-testkit_2.12-1.1.0.jar;%APP_LIB_DIR%\com.github.spullara.mustache.java.compiler-0.9.5.jar;%APP_LIB_DIR%\io.netty.netty-handler-4.1.24.Final.jar;%APP_LIB_DIR%\io.netty.netty-buffer-4.1.24.Final.jar;%APP_LIB_DIR%\io.netty.netty-common-4.1.24.Final.jar;%APP_LIB_DIR%\io.netty.netty-transport-4.1.24.Final.jar;%APP_LIB_DIR%\io.netty.netty-resolver-4.1.24.Final.jar;%APP_LIB_DIR%\io.netty.netty-codec-4.1.24.Final.jar;%APP_LIB_DIR%\org.bitlet.weupnp-0.1.4.jar;%APP_LIB_DIR%\org.asynchttpclient.async-http-client-2.4.7.jar;%APP_LIB_DIR%\org.asynchttpclient.async-http-client-netty-utils-2.4.7.jar;%APP_LIB_DIR%\org.slf4j.slf4j-api-1.7.25.jar;%APP_LIB_DIR%\io.netty.netty-codec-http-4.1.24.Final.jar;%APP_LIB_DIR%\io.netty.netty-codec-socks-4.1.24.Final.jar;%APP_LIB_DIR%\io.netty.netty-handler-proxy-4.1.24.Final.jar;%APP_LIB_DIR%\io.netty.netty-transport-native-epoll-4.1.24.Final-linux-x86_64.jar;%APP_LIB_DIR%\io.netty.netty-transport-native-unix-common-4.1.24.Final.jar;%APP_LIB_DIR%\io.netty.netty-resolver-dns-4.1.24.Final.jar;%APP_LIB_DIR%\io.netty.netty-codec-dns-4.1.24.Final.jar;%APP_LIB_DIR%\com.typesafe.netty.netty-reactive-streams-2.0.0.jar;%APP_LIB_DIR%\org.ethereum.leveldbjni-all-1.18.3.jar;%APP_LIB_DIR%\io.swagger.core.v3.swagger-core-2.0.5.jar;%APP_LIB_DIR%\javax.xml.bind.jaxb-api-2.3.0.jar;%APP_LIB_DIR%\org.apache.commons.commons-lang3-3.7.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-databind-2.9.6.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-core-2.9.6.jar;%APP_LIB_DIR%\org.yaml.snakeyaml-1.18.jar;%APP_LIB_DIR%\io.swagger.core.v3.swagger-annotations-2.0.5.jar;%APP_LIB_DIR%\io.swagger.core.v3.swagger-models-2.0.5.jar;%APP_LIB_DIR%\javax.validation.validation-api-1.1.0.Final.jar;%APP_LIB_DIR%\io.swagger.core.v3.swagger-jaxrs2-2.0.5.jar;%APP_LIB_DIR%\org.reflections.reflections-0.9.11.jar;%APP_LIB_DIR%\org.javassist.javassist-3.22.0-GA.jar;%APP_LIB_DIR%\io.swagger.core.v3.swagger-integration-2.0.5.jar;%APP_LIB_DIR%\com.fasterxml.jackson.jaxrs.jackson-jaxrs-json-provider-2.9.5.jar;%APP_LIB_DIR%\com.fasterxml.jackson.jaxrs.jackson-jaxrs-base-2.9.5.jar;%APP_LIB_DIR%\com.fasterxml.jackson.module.jackson-module-jaxb-annotations-2.9.5.jar;%APP_LIB_DIR%\io.swagger.swagger-scala-module_2.12-1.0.4.jar;%APP_LIB_DIR%\com.google.guava.guava-21.0.jar;%APP_LIB_DIR%\com.fasterxml.jackson.module.jackson-module-scala_2.12-2.9.6.jar;%APP_LIB_DIR%\org.scala-lang.scala-reflect-2.12.6.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-annotations-2.9.6.jar;%APP_LIB_DIR%\com.fasterxml.jackson.module.jackson-module-paranamer-2.9.6.jar;%APP_LIB_DIR%\com.thoughtworks.paranamer.paranamer-2.8.jar;%APP_LIB_DIR%\com.github.swagger-akka-http.swagger-akka-http_2.12-1.0.0.jar;%APP_LIB_DIR%\org.scala-lang.modules.scala-java8-compat_2.12-0.8.0.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-stream_2.12-2.5.14.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-actor_2.12-2.5.16.jar;%APP_LIB_DIR%\com.typesafe.config-1.3.3.jar;%APP_LIB_DIR%\com.typesafe.ssl-config-core_2.12-0.2.3.jar;%APP_LIB_DIR%\org.scala-lang.modules.scala-parser-combinators_2.12-1.1.0.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-http_2.12-10.1.4.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-http-core_2.12-10.1.4.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-parsing_2.12-10.1.4.jar;%APP_LIB_DIR%\io.swagger.swagger-core-1.5.20.jar;%APP_LIB_DIR%\com.fasterxml.jackson.dataformat.jackson-dataformat-yaml-2.9.6.jar;%APP_LIB_DIR%\io.swagger.swagger-models-1.5.20.jar;%APP_LIB_DIR%\io.swagger.swagger-annotations-1.5.20.jar;%APP_LIB_DIR%\io.swagger.swagger-jaxrs-1.5.20.jar;%APP_LIB_DIR%\javax.ws.rs.jsr311-api-1.1.1.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-slf4j_2.12-2.5.16.jar;%APP_LIB_DIR%\com.typesafe.play.play-json_2.12-2.6.10.jar;%APP_LIB_DIR%\com.typesafe.play.play-functional_2.12-2.6.10.jar;%APP_LIB_DIR%\joda-time.joda-time-2.9.9.jar;%APP_LIB_DIR%\com.fasterxml.jackson.datatype.jackson-datatype-jdk8-2.8.11.jar;%APP_LIB_DIR%\com.fasterxml.jackson.datatype.jackson-datatype-jsr310-2.8.11.jar;%APP_LIB_DIR%\ch.qos.logback.logback-classic-1.2.3.jar;%APP_LIB_DIR%\ch.qos.logback.logback-core-1.2.3.jar;%APP_LIB_DIR%\org.slf4j.jul-to-slf4j-1.7.25.jar;%APP_LIB_DIR%\net.logstash.logback.logstash-logback-encoder-4.11.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-persistence_2.12-2.5.16.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-protobuf_2.12-2.5.16.jar;%APP_LIB_DIR%\io.kamon.kamon-core_2.12-1.1.3.jar;%APP_LIB_DIR%\org.hdrhistogram.HdrHistogram-2.1.9.jar;%APP_LIB_DIR%\com.lihaoyi.fansi_2.12-0.2.4.jar;%APP_LIB_DIR%\io.kamon.kamon-system-metrics_2.12-1.0.0.jar;%APP_LIB_DIR%\io.kamon.sigar-loader-1.6.5-rev002.jar;%APP_LIB_DIR%\io.kamon.kamon-akka-2.5_2.12-1.1.1.jar;%APP_LIB_DIR%\io.kamon.kamon-scala-future_2.12-1.0.0.jar;%APP_LIB_DIR%\io.kamon.kamon-executors_2.12-1.0.1.jar;%APP_LIB_DIR%\io.kamon.kamon-influxdb_2.12-1.0.2.jar;%APP_LIB_DIR%\org.influxdb.influxdb-java-2.11.jar;%APP_LIB_DIR%\com.squareup.retrofit2.retrofit-2.4.0.jar;%APP_LIB_DIR%\com.squareup.okhttp3.okhttp-3.10.0.jar;%APP_LIB_DIR%\com.squareup.okio.okio-1.14.0.jar;%APP_LIB_DIR%\com.squareup.retrofit2.converter-moshi-2.4.0.jar;%APP_LIB_DIR%\com.squareup.moshi.moshi-1.5.0.jar;%APP_LIB_DIR%\com.squareup.okhttp3.logging-interceptor-3.10.0.jar;%APP_LIB_DIR%\com.iheart.ficus_2.12-1.4.2.jar;%APP_LIB_DIR%\commons-net.commons-net-3.6.jar"
set "APP_MAIN_CLASS=com.wavesplatform.Application"
set "SCRIPT_CONF_FILE=%APP_HOME%\conf\application.ini"

rem if configuration files exist, prepend their contents to the script arguments so it can be processed by this runner
call :parse_config "%SCRIPT_CONF_FILE%" SCRIPT_CONF_ARGS

call :process_args %SCRIPT_CONF_ARGS% %%*

set _JAVA_OPTS=!_JAVA_OPTS! !_JAVA_PARAMS!

if defined CUSTOM_MAIN_CLASS (
    set MAIN_CLASS=!CUSTOM_MAIN_CLASS!
) else (
    set MAIN_CLASS=!APP_MAIN_CLASS!
)

rem Call the application and pass all arguments unchanged.
"%_JAVACMD%" !_JAVA_OPTS! !FLG_OPTS! -cp "%APP_CLASSPATH%" %MAIN_CLASS% !_APP_ARGS!

@endlocal

exit /B %ERRORLEVEL%


rem Loads a configuration file full of default command line options for this script.
rem First argument is the path to the config file.
rem Second argument is the name of the environment variable to write to.
:parse_config
  set _PARSE_FILE=%~1
  set _PARSE_OUT=
  if exist "%_PARSE_FILE%" (
    FOR /F "tokens=* eol=# usebackq delims=" %%i IN ("%_PARSE_FILE%") DO (
      set _PARSE_OUT=!_PARSE_OUT! %%i
    )
  )
  set %2=!_PARSE_OUT!
exit /B 0


:add_java
  set _JAVA_PARAMS=!_JAVA_PARAMS! %*
exit /B 0


:add_app
  set _APP_ARGS=!_APP_ARGS! %*
exit /B 0


rem Processes incoming arguments and places them in appropriate global variables
:process_args
  :param_loop
  call set _PARAM1=%%1
  set "_TEST_PARAM=%~1"

  if ["!_PARAM1!"]==[""] goto param_afterloop


  rem ignore arguments that do not start with '-'
  if "%_TEST_PARAM:~0,1%"=="-" goto param_java_check
  set _APP_ARGS=!_APP_ARGS! !_PARAM1!
  shift
  goto param_loop

  :param_java_check
  if "!_TEST_PARAM:~0,2!"=="-J" (
    rem strip -J prefix
    set _JAVA_PARAMS=!_JAVA_PARAMS! !_TEST_PARAM:~2!
    shift
    goto param_loop
  )

  if "!_TEST_PARAM:~0,2!"=="-D" (
    rem test if this was double-quoted property "-Dprop=42"
    for /F "delims== tokens=1,*" %%G in ("!_TEST_PARAM!") DO (
      if not ["%%H"] == [""] (
        set _JAVA_PARAMS=!_JAVA_PARAMS! !_PARAM1!
      ) else if [%2] neq [] (
        rem it was a normal property: -Dprop=42 or -Drop="42"
        call set _PARAM1=%%1=%%2
        set _JAVA_PARAMS=!_JAVA_PARAMS! !_PARAM1!
        shift
      )
    )
  ) else (
    if "!_TEST_PARAM!"=="-main" (
      call set CUSTOM_MAIN_CLASS=%%2
      shift
    ) else (
      set _APP_ARGS=!_APP_ARGS! !_PARAM1!
    )
  )
  shift
  goto param_loop
  :param_afterloop

exit /B 0

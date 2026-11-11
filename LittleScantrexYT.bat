@echo off
setlocal EnableExtensions
title LittleScantrexYT

rem ---------- Colores ANSI (Windows 10 o superior) ----------
for /F "delims=#" %%E in ('"prompt #$E# & for %%E in (1) do rem"') do set "ESC=%%E"
set "RED=%ESC%[91m"
set "WHT=%ESC%[97m"
set "GRY=%ESC%[90m"
set "GRN=%ESC%[92m"
set "YEL=%ESC%[93m"
set "RST=%ESC%[0m"

rem ---------- Calidades ----------
set "L1=1  -  Maxima resolucion posible"
set "L2=2  -  1080p   Full HD"
set "L3=3  -  720p    HD"
set "L4=4  -  480p    SD"
set "L5=5  -  360p    Ligera"
set "L6=R  -  Otra resolucion, la que tu quieras"
set "CUSTOM="
set "MSG="
set "QSEL=1"

rem ---------- Carpetas (OUT siempre termina en barra invertida) ----------
set "HERR=%~dp0herramientas"
set "OUT=%USERPROFILE%\Downloads\"
if not exist "%HERR%" mkdir "%HERR%" >nul 2>&1
if not exist "%HERR%" goto err_perm
set "PATH=%HERR%;%PATH%"

rem ---------- Preparar herramientas (solo la primera vez) ----------
:preparar
cls
call :banner
if exist "%HERR%\yt-dlp.exe" goto chk_deno
echo   %YEL%Primera vez: descargando yt-dlp...%RST%
call :bajar "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" "%HERR%\yt-dlp.part"
if errorlevel 1 goto err_tools
move /y "%HERR%\yt-dlp.part" "%HERR%\yt-dlp.exe" >nul
"%HERR%\yt-dlp.exe" --version >nul 2>&1
if errorlevel 1 goto err_ytdlp

:chk_deno
where deno >nul 2>&1
if not errorlevel 1 goto chk_ffmpeg
echo.
echo   %YEL%Primera vez: descargando Deno, unos 40 MB...%RST%
call :bajar "https://github.com/denoland/deno/releases/latest/download/deno-x86_64-pc-windows-msvc.zip" "%HERR%\_tmp.zip"
if errorlevel 1 goto err_tools
call :unzip

:chk_ffmpeg
where ffmpeg >nul 2>&1
if not errorlevel 1 goto chk_final
echo.
echo   %YEL%Primera vez: descargando ffmpeg, unos 200 MB. Puede tardar unos minutos...%RST%
call :bajar "https://github.com/yt-dlp/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip" "%HERR%\_tmp.zip"
if errorlevel 1 goto err_tools
call :unzip

:chk_final
where deno >nul 2>&1
if errorlevel 1 goto err_tools
where ffmpeg >nul 2>&1
if errorlevel 1 goto err_tools

rem ---------- Pantalla principal ----------
:menu
cls
call :banner
if defined MSG echo   %MSG%
if defined MSG echo.
set "MSG="
echo   %GRY%CALIDAD  -  pulsa 1 al 5, o R para escribir la tuya%RST%
echo.
for %%i in (1 2 3 4 5 6) do call :linea %%i
echo.
echo   %GRY%GUARDAR EN%RST%
<nul set /p "=    %WHT%%OUT%%RST%"
echo.
echo.
echo   %RED%[D]%RST% Descargar     %RED%[C]%RST% Cambiar carpeta     %RED%[A]%RST% Abrir carpeta
echo   %GRY%[U] Actualizar yt-dlp                          [S] Salir%RST%
echo.
choice /c 12345RDCAUS /n /m "  Tu opcion: "
set "Q=%errorlevel%"
if %Q% GEQ 12 goto menu
if %Q% LEQ 0 goto menu
if %Q% EQU 11 goto salir
if %Q% EQU 10 goto actualizar
if %Q% EQU 9 goto abrir
if %Q% EQU 8 goto carpeta
if %Q% EQU 7 goto descargar
if %Q% EQU 6 goto custom
set "QSEL=%Q%"
goto menu

rem ---------- Resolucion personalizada ----------
:custom
echo.
set "TMP_R="
set /p "TMP_R=  Escribe la resolucion, por ejemplo 2160, 1440, 240 o 144: "
if not defined TMP_R goto menu
set "TMP_R=%TMP_R:p=%"
set "TMP_R=%TMP_R: =%"
if not defined TMP_R goto custom_mal
for /f "delims=0123456789" %%x in ("%TMP_R%") do goto custom_mal
:ceros
if not defined TMP_R goto custom_mal
if not "%TMP_R:~0,1%"=="0" goto custom_ok
set "TMP_R=%TMP_R:~1%"
goto ceros
:custom_ok
if not "%TMP_R:~5%"=="" goto custom_mal
set "CUSTOM=%TMP_R%"
set "L6=R  -  Personalizada: %CUSTOM%p"
set "QSEL=6"
goto menu
:custom_mal
set "MSG=%RED%Resolucion no valida. Escribe solo un numero, por ejemplo 1440.%RST%"
goto menu

rem ---------- Descargar ----------
rem Con -S "res:N" baja la mejor calidad que no pase de N. Si el video no llega
rem a N, baja la mejor que tenga. Si solo tiene mayores, baja la mas pequena.
:descargar
set "H=0"
if "%QSEL%"=="2" set "H=1080"
if "%QSEL%"=="3" set "H=720"
if "%QSEL%"=="4" set "H=480"
if "%QSEL%"=="5" set "H=360"
if "%QSEL%"=="6" set "H=%CUSTOM%"
if "%H%"=="0" goto sort_max
set "SORT=res:%H%,vcodec:h264,acodec:aac"
goto pedir
:sort_max
set "SORT=res,vcodec:h264,acodec:aac"

:pedir
if not exist "%OUT%" mkdir "%OUT%" >nul 2>&1
if not exist "%OUT%" goto sin_carpeta
echo.
echo   %GRY%LINK DEL VIDEO  -  Enter vacio para volver al menu%RST%
set "URL="
set /p "URL=  > Pega el link: "
if not defined URL goto menu
if /i not "%URL:~0,4%"=="http" goto link_mal
set "PLOPT=--no-playlist"
if "%URL:playlist?list=%"=="%URL%" goto go_dl
echo.
echo   %YEL%Este link es una lista de reproduccion completa.%RST%
choice /c SN /m "  Descargar TODOS los videos de la lista"
if errorlevel 2 goto menu
set "PLOPT=--yes-playlist"

:go_dl
echo.
echo   %YEL%Descargando...%RST%
echo.
"%HERR%\yt-dlp.exe" %PLOPT% -f "bv*+ba/b" -S "%SORT%" --merge-output-format mp4 --windows-filenames --trim-filenames 150 --no-mtime -N 4 -P "%OUT%." -o "%%(title)s [%%(id)s].%%(ext)s" "%URL%"
if errorlevel 1 goto fallo
set "MSG=%GRN%Listo. Video descargado en tu carpeta. Puedes descargar otro.%RST%"
goto menu

:link_mal
set "MSG=%RED%Eso no parece un link. Debe empezar por http.%RST%"
goto menu

:sin_carpeta
set "MSG=%RED%No se pudo crear la carpeta de destino. Pulsa C y elige otra.%RST%"
goto menu

:fallo
echo.
echo   %RED%No se pudo descargar.%RST% Posibles causas:
echo     - Link incorrecto, video privado, con restriccion de edad o de pais
echo     - yt-dlp desactualizado: en el menu pulsa U
echo     - Sin conexion a internet
echo.
echo   Pulsa una tecla para volver al menu...
pause >nul
set "MSG=%RED%La ultima descarga fallo. Revisa el link o pulsa U para actualizar.%RST%"
goto menu

rem ---------- Otras opciones ----------
:carpeta
set "NEWOUT="
for /f "usebackq delims=" %%f in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-Type -AssemblyName System.Windows.Forms; $f=New-Object System.Windows.Forms.Form; $f.TopMost=$true; $d=New-Object System.Windows.Forms.FolderBrowserDialog; $d.Description='Elige donde guardar los videos'; if($d.ShowDialog($f) -eq 'OK'){$d.SelectedPath}"`) do set "NEWOUT=%%f"
if not defined NEWOUT goto menu
if not "%NEWOUT:~-1%"=="\" set "NEWOUT=%NEWOUT%\"
set "OUT=%NEWOUT%"
goto menu

:abrir
if not exist "%OUT%" mkdir "%OUT%" >nul 2>&1
start "" "%OUT%."
goto menu

:actualizar
echo.
"%HERR%\yt-dlp.exe" -U
echo.
echo   Pulsa una tecla para volver al menu...
pause >nul
goto menu

rem ---------- Errores de arranque ----------
:err_perm
echo.
echo   No se puede crear la carpeta "herramientas" en este lugar.
echo   Mueve este archivo al Escritorio o a Documentos y abrelo de nuevo.
echo.
pause
goto salir

:err_ytdlp
del "%HERR%\yt-dlp.exe" >nul 2>&1
echo.
echo   %RED%No se pudo ejecutar yt-dlp.%RST%
echo   Puede que el antivirus lo haya bloqueado o que la descarga quedara incompleta.
echo   Abre el programa otra vez para intentarlo de nuevo.
echo.
pause
goto salir

:err_tools
del "%HERR%\_tmp.zip" >nul 2>&1
del "%HERR%\yt-dlp.part" >nul 2>&1
echo.
echo   %RED%No se pudieron preparar las herramientas.%RST%
echo   Revisa tu conexion a internet o si el antivirus bloquea la descarga,
echo   y vuelve a abrir el programa. Se reanuda donde se quedo.
echo.
pause
goto salir

:salir
endlocal
exit /b

rem ---------- Subrutinas ----------
:linea
set "M=[ ]"
set "C=%WHT%"
if "%QSEL%"=="%~1" set "M=[X]" & set "C=%RED%"
call set "T=%%L%~1%%"
echo     %C%%M%  %T%%RST%
exit /b

:bajar
where curl.exe >nul 2>&1
if errorlevel 1 goto bajar_ps
curl.exe -L --fail --retry 3 -# -o "%~2" "%~1"
exit /b
:bajar_ps
set "DL_URL=%~1"
set "DL_OUT=%~2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -UseBasicParsing -Uri $env:DL_URL -OutFile $env:DL_OUT"
exit /b

:unzip
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; $zp=Join-Path $env:HERR '_tmp.zip'; $z=[IO.Compression.ZipFile]::OpenRead($zp); foreach($e in $z.Entries){ if(@('deno.exe','ffmpeg.exe','ffprobe.exe') -contains $e.Name){ [IO.Compression.ZipFileExtensions]::ExtractToFile($e,(Join-Path $env:HERR $e.Name),$true) } }; $z.Dispose()"
del "%HERR%\_tmp.zip" >nul 2>&1
exit /b

:banner
echo.
echo   %RED%+--------------------------------------+%RST%
echo   %RED%^|%RST%   %RED%^>%RST%  %WHT%LittleScantrex%RED%YT%RST%                %RED%^|%RST%
echo   %RED%+--------------------------------------+%RST%
echo   %GRY%Descarga tus videos en MP4 con la calidad que elijas%RST%
echo.
exit /b

@echo off
REM ============================================================
REM  setup_assets_icons_splash.bat
REM  Objetivo:
REM   - Asegurar estructura assets\icons
REM   - Mover icono.jpg (si está en la raíz) -> assets\icons\icono.jpg
REM   - Agregar dependencias y configuraciones:
REM       * flutter_launcher_icons (iconos del app)
REM       * flutter_native_splash (splash screen)
REM   - Escribir bloques de config al FINAL del pubspec.yaml (nivel raíz)
REM     sin tocar secciones de dependencies/dev_dependencies.
REM   - Ejecutar:
REM       1) flutter pub get
REM       2) dart run flutter_launcher_icons
REM       3) dart run flutter_native_splash:create
REM       4) flutter run
REM
REM  Notas de diseño del splash:
REM   - Solo Android
REM   - Fondo blanco
REM   - Misma imagen para Android 12+
REM   - Ruta de imagen: assets/icons/icono.jpg
REM ============================================================

setlocal EnableExtensions EnableDelayedExpansion

REM --- Validación: debe existir pubspec.yaml
if not exist "pubspec.yaml" (
  echo [ERROR] No se encontro pubspec.yaml en el directorio actual.
  echo         Ejecuta este script desde la RAIZ del proyecto Flutter.
  exit /b 1
)

echo [INFO] Inicio: %DATE% %TIME%

REM ------------------------------------------------------------
REM PASO 0) Preparar carpetas e imagen
REM   - Crear assets\icons
REM   - Si existe icono.jpg en la raiz, moverlo a assets\icons\icono.jpg
REM ------------------------------------------------------------
echo.
echo [PASO 0] Preparando estructura de assets\icons y moviendo icono.jpg (si aplica)

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "New-Item -ItemType Directory -Path 'assets\icons' -Force | Out-Null;"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$src = 'icono.jpg';" ^
  "$dst = 'assets\icons\icono.jpg';" ^
  "if (Test-Path $src) {" ^
  "  if (Test-Path $dst) {" ^
  "    Write-Host '[INFO] Ya existe ' $dst ' ; no se sobreescribe.';" ^
  "  } else {" ^
  "    Move-Item -LiteralPath $src -Destination $dst;" ^
  "    Write-Host '[OK] Movido ' $src ' -> ' $dst;" ^
  "  }" ^
  "} else {" ^
  "  Write-Host '[INFO] No se encontro icono.jpg en la raiz; continuando...';" ^
  "}"

if not exist "assets\icons\icono.jpg" (
  echo [AVISO] No se encontro assets\icons\icono.jpg tras el paso 0.
  echo        Coloca tu icono ahi para evitar errores al generar splash/iconos.
)

REM ------------------------------------------------------------
REM PASO 1) flutter pub add flutter_launcher_icons
REM ------------------------------------------------------------
echo.
echo [PASO 1] Ejecutando: flutter pub add flutter_launcher_icons
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "flutter pub add flutter_launcher_icons"
if errorlevel 1 (
  echo [ERROR] Fallo: flutter pub add flutter_launcher_icons
  exit /b 1
)

REM ------------------------------------------------------------
REM PASO 1.1) flutter pub add flutter_native_splash
REM   (Dependencia para generar splash en Android con la misma imagen)
REM ------------------------------------------------------------
echo.
echo [PASO 1.1] Ejecutando: flutter pub add flutter_native_splash
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "flutter pub add flutter_native_splash"
if errorlevel 1 (
  echo [ERROR] Fallo: flutter pub add flutter_native_splash
  exit /b 1
)

REM ------------------------------------------------------------
REM PASO 2) Asegurar bloque de configuracion de flutter_launcher_icons
REM   - Solo si NO existe ya un bloque raiz 'flutter_launcher_icons:'
REM   - Ruta de imagen: assets/icons/icono.jpg
REM ------------------------------------------------------------
echo.
echo [PASO 2] Configurando bloque flutter_launcher_icons en pubspec.yaml

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$path = 'pubspec.yaml';" ^
  "$content = Get-Content $path -Raw;" ^
  "$hasRootIcons = $content -match '(?m)^\s*flutter_launcher_icons:\s*$';" ^
  "if ($hasRootIcons) {" ^
  "  Write-Host '[INFO] Ya existe flutter_launcher_icons: en el pubspec. No se duplica.';" ^
  "} else {" ^
  "  $block = \"`r`nflutter_launcher_icons:`r`n  android: \"\"launcher_icon\"\"`r`n  image_path: \"\"assets/icons/icono.jpg\"\"\";" ^
  "  Add-Content -Path $path -Value $block;" ^
  "  Write-Host '[OK] Bloque flutter_launcher_icons agregado al FINAL del pubspec.yaml';" ^
  "}"

if errorlevel 1 (
  echo [ERROR] No se pudo escribir flutter_launcher_icons en pubspec.yaml
  exit /b 1
)

REM ------------------------------------------------------------
REM PASO 2.1) Asegurar bloque de configuracion de flutter_native_splash
REM   - Solo Android, fondo blanco, misma imagen para Android 12+
REM   - Solo si NO existe ya un bloque raiz 'flutter_native_splash:'
REM ------------------------------------------------------------
echo.
echo [PASO 2.1] Configurando bloque flutter_native_splash en pubspec.yaml

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$path = 'pubspec.yaml';" ^
  "$content = Get-Content $path -Raw;" ^
  "$hasRootSplash = $content -match '(?m)^\s*flutter_native_splash:\s*$';" ^
  "if ($hasRootSplash) {" ^
  "  Write-Host '[INFO] Ya existe flutter_native_splash: en el pubspec. No se duplica.';" ^
  "} else {" ^
  "  $block = \"`r`nflutter_native_splash:`r`n  android: true`r`n  ios: false`r`n  web: false`r`n  color: \"\"#ffffff\"\"`r`n  image: \"\"assets/icons/icono.jpg\"\"`r`n  android_12:`r`n    image: \"\"assets/icons/icono.jpg\"\"`r`n    color: \"\"#ffffff\"\"\";" ^
  "  Add-Content -Path $path -Value $block;" ^
  "  Write-Host '[OK] Bloque flutter_native_splash agregado al FINAL del pubspec.yaml';" ^
  "}"

if errorlevel 1 (
  echo [ERROR] No se pudo escribir flutter_native_splash en pubspec.yaml
  exit /b 1
)

REM ------------------------------------------------------------
REM PASO 3) flutter pub get
REM ------------------------------------------------------------
echo.
echo [PASO 3] Ejecutando: flutter pub get
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "flutter pub get"
if errorlevel 1 (
  echo [ERROR] Fallo: flutter pub get
  exit /b 1
)

REM ------------------------------------------------------------
REM PASO 4) Generar ICONOS
REM ------------------------------------------------------------
echo.
echo [PASO 4] Ejecutando: dart run flutter_launcher_icons
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "dart run flutter_launcher_icons"
if errorlevel 1 (
  echo [ERROR] Fallo: dart run flutter_launcher_icons
  echo         Verifica que assets/icons/icono.jpg exista y YAML sea valido.
  exit /b 1
)

REM ------------------------------------------------------------
REM PASO 4.1) Generar SPLASH
REM   - Usa el bloque flutter_native_splash del pubspec.yaml
REM ------------------------------------------------------------
echo.
echo [PASO 4.1] Ejecutando: dart run flutter_native_splash:create
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "dart run flutter_native_splash:create"
if errorlevel 1 (
  echo [ERROR] Fallo: dart run flutter_native_splash:create
  echo         Revisa la ruta de imagen y el bloque flutter_native_splash.
  exit /b 1
)

REM ------------------------------------------------------------
REM PASO 5) Ejecutar la app
REM ------------------------------------------------------------
echo.
echo [PASO 5] Ejecutando: flutter run
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "flutter run"
if errorlevel 1 (
  echo [ERROR] Fallo: flutter run
  echo         Verifica tener un dispositivo/emulador activo (flutter devices).
  exit /b 1
)

echo.
echo [LISTO] Iconos y splash generados, app lanzada. %DATE% %TIME%
exit /b 0

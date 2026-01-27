mkdir build-cpp
cd build-cpp
if errorlevel 1 exit 1


IF not x%PKG_NAME:static=%==x%PKG_NAME% (
    set BUILD_TYPE="-DBUILD_SHARED_LIBS=OFF"
) ELSE (
    set BUILD_TYPE="-DBUILD_SHARED_LIBS=ON"
)

cmake -G "Ninja" ^
      %CMAKE_ARGS% ^
      %BUILD_TYPE% ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_INSTALL_LIBDIR=lib ^
      -DREPROC_TEST=ON ^
      -DREPROC++=ON ^
      %SRC_DIR%

ninja
if "%target_platform%"=="win-arm64" (
    echo Skipping tests on win-arm64 due to known env inheritance differences
) else (
    ninja test
)
if errorlevel 1 exit 1

ninja install
if errorlevel 1 exit 1

IF not x%PKG_NAME:static=%==x%PKG_NAME% (
    REN %LIBRARY_PREFIX%\lib\reproc++.lib reproc++_static.lib
)

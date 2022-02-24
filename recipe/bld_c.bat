mkdir build
cd build
if errorlevel 1 exit 1

IF not x%PKG_NAME:static=%==x%PKG_NAME% (
    set BUILD_TYPE=-DBUILD_SHARED_LIBS=OFF
) ELSE (
    set BUILD_TYPE=-DBUILD_SHARED_LIBS=ON
)

cmake -G "Ninja" ^
      %CMAKE_ARGS% ^
      %BUILD_TYPE% ^
      -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_INSTALL_LIBDIR=lib ^
      -DREPROC_TEST=ON ^
      %SRC_DIR%

ninja install
if errorlevel 1 exit 1

IF not x%PKG_NAME:static=%==x%PKG_NAME% (
    REN %LIBRARY_PREFIX%\lib\reproc.lib reproc_static.lib
)

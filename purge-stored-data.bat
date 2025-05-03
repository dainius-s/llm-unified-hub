@echo off
setlocal enabledelayedexpansion

:: Get the script's directory (your project root)
set "BASEDIR=%~dp0"

echo.
echo ⚠️  This will delete all contents in mounted Docker data folders:
echo    - open-webui\
echo    - data\postgres\
echo    - caddy\data\
echo    - caddy\config\
echo.
set /p confirm="Are you sure you want to continue? (y/N): "
if /i not "%confirm%"=="y" (
    echo Aborted.
    exit /b
)

:: List of folders to purge
set "DIRS=open-webui data\postgres caddy\data caddy\config"

:: List of filenames to preserve (add more as needed)
set "PRESERVE=.gitignore .gitkeep"

for %%D in (%DIRS%) do (
    set "TARGET=!BASEDIR!%%D"
    if exist "!TARGET!" (
        echo Purging %%D ...

        pushd "!TARGET!" >nul

        :: Delete files except those we want to preserve
        for %%F in (*.*) do (
            set "SKIP=0"
            for %%P in (%PRESERVE%) do (
                if /i "%%F"=="%%P" set "SKIP=1"
            )
            if "!SKIP!"=="0" del /f /q "%%F" >nul 2>&1
        )

        :: Delete subdirectories
        for /d %%X in (*) do (
            rd /s /q "%%X"
        )

        popd >nul
    ) else (
        echo Skipping %%D (not found)
    )
)

echo.
echo ✅ Done. Selected data folders have been purged (preserved .gitignore, .gitkeep).

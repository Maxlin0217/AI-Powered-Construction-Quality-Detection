@echo off
echo Generating App Icons...
echo.
python generate_icons.py
echo.
if errorlevel 1 (
    echo Failed! Please install Pillow:
    echo pip install Pillow --break-system-packages
) else (
    echo Success! Icons created:
    echo - icon-192.png
    echo - icon-512.png
)
echo.
pause

@echo off
cls
echo =======================================
echo    PWA Deployment Tool
echo    YOLO Detection App
echo =======================================
echo.

echo [File Check]
echo.

if exist manifest.json (
    echo OK: manifest.json
) else (
    echo ERROR: manifest.json not found
    goto :error
)

if exist service-worker.js (
    echo OK: service-worker.js
) else (
    echo ERROR: service-worker.js not found
    goto :error
)

if exist yolo-smart-detection.html (
    echo OK: yolo-smart-detection.html
) else (
    echo ERROR: yolo-smart-detection.html not found
    goto :error
)

if exist icon-192.png (
    echo OK: icon-192.png
) else (
    echo WARNING: icon-192.png not found
    echo Please generate icons first
    set NEED_ICONS=1
)

if exist icon-512.png (
    echo OK: icon-512.png
) else (
    echo WARNING: icon-512.png not found
    set NEED_ICONS=1
)

echo.
echo =======================================
echo.

if defined NEED_ICONS (
    echo [Generate Icons]
    echo.
    echo Icons are missing. Options:
    echo   1 - Generate default icons (requires Python + Pillow)
    echo   2 - I will prepare icons manually
    echo   3 - Skip for now
    echo.
    choice /C 123 /N /M "Choose [1/2/3]: "
    
    if errorlevel 3 goto :skip_icons
    if errorlevel 2 (
        echo.
        echo Please prepare:
        echo   - icon-192.png (192x192 pixels)
        echo   - icon-512.png (512x512 pixels)
        echo.
        echo Tool: https://www.favicon-generator.org/
        echo.
        pause
        goto :skip_icons
    )
    if errorlevel 1 (
        echo.
        echo Generating icons...
        python generate_icons.py
        if errorlevel 1 (
            echo.
            echo Icon generation failed
            echo Install Pillow: pip install Pillow --break-system-packages
            echo.
            pause
            goto :skip_icons
        )
        echo.
        echo Icons generated successfully
        echo.
    )
)

:skip_icons

echo [Starting Server]
echo.
echo Starting HTTP server...
echo.
echo Access via:
echo   PC: http://localhost:8000/yolo-smart-detection.html
echo   Mobile: http://YOUR_IP:8000/yolo-smart-detection.html
echo.
echo Do NOT close this window!
echo.
echo =======================================
echo.

timeout /t 2 >nul
start http://localhost:8000/yolo-smart-detection.html

python -m http.server 8000

goto :end

:error
echo.
echo =======================================
echo    Deployment Failed
echo =======================================
echo.
echo Missing required files. Please ensure these files exist:
echo   - manifest.json
echo   - service-worker.js
echo   - yolo-smart-detection.html
echo.
echo Tip: Copy these files from the output folder
echo.
pause
exit /b 1

:end
pause

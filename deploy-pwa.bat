@echo off
chcp 65001 >nul
cls
echo =======================================
echo    PWA 自動部署工具
echo    YOLOv11 混凝土缺陷檢測 App
echo =======================================
echo.

echo [檢查清單]
echo.

REM 檢查 manifest.json
if exist manifest.json (
    echo ✅ manifest.json
) else (
    echo ❌ manifest.json 未找到
    goto :error
)

REM 檢查 service-worker.js
if exist service-worker.js (
    echo ✅ service-worker.js
) else (
    echo ❌ service-worker.js 未找到
    goto :error
)

REM 檢查主 HTML
if exist yolo-smart-detection.html (
    echo ✅ yolo-smart-detection.html
) else (
    echo ❌ yolo-smart-detection.html 未找到
    goto :error
)

REM 檢查圖標
if exist icon-192.png (
    echo ✅ icon-192.png
) else (
    echo ⚠️  icon-192.png 未找到（稍後需要生成）
    set NEED_ICONS=1
)

if exist icon-512.png (
    echo ✅ icon-512.png
) else (
    echo ⚠️  icon-512.png 未找到（稍後需要生成）
    set NEED_ICONS=1
)

echo.
echo =======================================
echo.

if defined NEED_ICONS (
    echo [生成圖標]
    echo.
    echo 檢測到缺少圖標，是否要自動生成？
    echo.
    echo 選項：
    echo   1 - 自動生成預設圖標
    echo   2 - 我自己準備圖標
    echo   3 - 跳過（稍後補充）
    echo.
    choice /C 123 /N /M "請選擇 [1/2/3]: "
    
    if errorlevel 3 goto :skip_icons
    if errorlevel 2 (
        echo.
        echo 📋 請準備以下圖標：
        echo    - icon-192.png (192x192 像素)
        echo    - icon-512.png (512x512 像素)
        echo.
        echo 推薦工具：https://www.favicon-generator.org/
        echo.
        pause
        goto :skip_icons
    )
    if errorlevel 1 (
        echo.
        echo 正在生成圖標...
        python generate_icons.py
        if errorlevel 1 (
            echo.
            echo ❌ 圖標生成失敗
            echo 請確保已安裝 Pillow: pip install Pillow --break-system-packages
            echo.
            pause
            goto :skip_icons
        )
        echo.
        echo ✅ 圖標生成成功
        echo.
    )
)

:skip_icons

echo [啟動測試伺服器]
echo.
echo 正在啟動 HTTPS 測試伺服器...
echo.
echo 📱 訪問方式：
echo    電腦：http://localhost:8000/yolo-smart-detection.html
echo    手機：http://您的IP:8000/yolo-smart-detection.html
echo.
echo ⚠️  請勿關閉此視窗！
echo.
echo =======================================
echo.

REM 啟動瀏覽器
timeout /t 2 >nul
start http://localhost:8000/yolo-smart-detection.html

REM 啟動伺服器
python -m http.server 8000

goto :end

:error
echo.
echo =======================================
echo    ❌ 部署失敗
echo =======================================
echo.
echo 缺少必要檔案，請確保以下檔案在同一資料夾：
echo   - manifest.json
echo   - service-worker.js
echo   - yolo-smart-detection.html
echo.
echo 💡 提示：
echo    從輸出資料夾複製這些檔案到當前目錄
echo.
pause
exit /b 1

:end
pause

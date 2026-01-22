@echo off
echo =======================================
echo    ONNX Runtime 下載工具
echo =======================================
echo.
echo 正在下載 ort.min.js...
echo.

curl -L -o ort.min.js https://unpkg.com/onnxruntime-web@1.19.2/dist/ort.min.js

if exist ort.min.js (
    echo.
    echo =======================================
    echo    下載成功！
    echo =======================================
    echo.
    echo 檔案已保存為: ort.min.js
    echo 大小: 
    dir ort.min.js | find "ort.min.js"
    echo.
    echo 請將此檔案與 yolo-final-fixed.html 放在同一資料夾
    echo.
) else (
    echo.
    echo =======================================
    echo    下載失敗
    echo =======================================
    echo.
    echo 請嘗試以下替代方案：
    echo 1. 使用瀏覽器直接下載：
    echo    https://unpkg.com/onnxruntime-web@1.19.2/dist/ort.min.js
    echo.
    echo 2. 或等待明天 CDN 恢復
    echo.
)

pause

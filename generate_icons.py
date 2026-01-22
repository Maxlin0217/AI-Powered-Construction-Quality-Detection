"""
App 圖標快速生成器
使用方法：python generate_icons.py
"""

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    print("❌ 未安裝 Pillow 庫")
    print("請執行：pip install Pillow --break-system-packages")
    exit(1)

def create_app_icon():
    print("🎨 正在生成 App 圖標...")
    
    # 創建 512x512 圖標
    size = 512
    img = Image.new('RGB', (size, size), color='#3282b8')
    draw = ImageDraw.Draw(img)
    
    # 繪製圓形背景
    padding = 50
    draw.ellipse(
        [padding, padding, size-padding, size-padding],
        fill='#2980b9',
        outline='white',
        width=15
    )
    
    # 繪製內圓
    inner_padding = 120
    draw.ellipse(
        [inner_padding, inner_padding, size-inner_padding, size-inner_padding],
        fill='#3498db',
        outline='white',
        width=10
    )
    
    # 添加文字（使用系統字體）
    try:
        # Windows
        font_large = ImageFont.truetype("msyh.ttc", 80)  # 微軟雅黑
        font_small = ImageFont.truetype("msyh.ttc", 50)
    except:
        try:
            # macOS
            font_large = ImageFont.truetype("/System/Library/Fonts/PingFang.ttc", 80)
            font_small = ImageFont.truetype("/System/Library/Fonts/PingFang.ttc", 50)
        except:
            print("⚠️ 無法載入中文字體，使用預設字體")
            font_large = ImageFont.load_default()
            font_small = ImageFont.load_default()
    
    # 繪製主要圖標（放大鏡）
    # 簡化版：繪製一個大圓和一條線代表放大鏡
    mag_center = (size // 2 - 30, size // 2 - 30)
    mag_radius = 80
    
    # 放大鏡圓圈
    draw.ellipse(
        [mag_center[0]-mag_radius, mag_center[1]-mag_radius,
         mag_center[0]+mag_radius, mag_center[1]+mag_radius],
        outline='white',
        width=12
    )
    
    # 放大鏡手柄
    handle_start = (mag_center[0] + mag_radius*0.7, mag_center[1] + mag_radius*0.7)
    handle_end = (mag_center[0] + mag_radius*1.5, mag_center[1] + mag_radius*1.5)
    draw.line([handle_start, handle_end], fill='white', width=15)
    
    # 裂縫圖案（簡化的鋸齒線）
    crack_y = size // 2 + 20
    draw.line(
        [(180, crack_y), (220, crack_y-15), (260, crack_y), (300, crack_y-20), (340, crack_y)],
        fill='#e74c3c',
        width=8
    )
    
    # 保存 512x512
    img.save('icon-512.png')
    print("✅ 已生成：icon-512.png")
    
    # 生成 192x192
    img_small = img.resize((192, 192), Image.LANCZOS)
    img_small.save('icon-192.png')
    print("✅ 已生成：icon-192.png")
    
    print("\n🎉 圖標生成完成！")
    print("📁 檔案位置：")
    print("   - icon-512.png (512x512)")
    print("   - icon-192.png (192x192)")
    print("\n📋 下一步：")
    print("   1. 將這兩個檔案複製到應用資料夾")
    print("   2. 確保 manifest.json 在同一資料夾")
    print("   3. 部署並測試！")

if __name__ == '__main__':
    create_app_icon()

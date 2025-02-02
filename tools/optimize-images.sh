#!/bin/bash

# 画像ファイルのディレクトリ
IMAGE_DIR="public/images"

# 必要なツールのインストールチェック
if ! command -v convert &> /dev/null; then
    echo "ImageMagick is not installed. Installing..."
    brew install imagemagick
fi

# 各画像ファイルに対して処理を実行
find "$IMAGE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r image; do
    echo "Processing $image..."

    # ベースファイル名（拡張子なし）
    basename=$(echo "$image" | sed 's/\.[^.]*$//')

    # 通常サイズの最適化とWebP変換
    convert "$image" -strip -quality 85 -resize "800x800>" "$image"
    convert "$image" -strip -quality 85 -resize "800x800>" "${basename}.webp"

    # 2倍サイズの生成
    convert "$image" -strip -quality 85 -resize "1600x1600>" "${basename}@2x${image##*.}"
    convert "$image" -strip -quality 85 -resize "1600x1600>" "${basename}@2x.webp"
done

echo "Image optimization complete!"
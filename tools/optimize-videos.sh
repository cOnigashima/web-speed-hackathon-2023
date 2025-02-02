#!/bin/bash

# 動画ファイルのディレクトリ
VIDEO_DIR="public/videos"

# 各動画ファイルに対して処理を実行
for video in "$VIDEO_DIR"/*.mp4; do
  if [ -f "$video" ]; then
    filename=$(basename "$video")
    output_webm="${video%.*}.webm"
    output_mp4_optimized="${video%.*}_optimized.mp4"

    echo "Processing $filename..."

    # WebM形式に変換
    ffmpeg -i "$video" -c:v libvpx-vp9 -crf 30 -b:v 0 -c:a libopus "$output_webm"

    # MP4の最適化
    ffmpeg -i "$video" -c:v libx264 -crf 23 -preset medium -c:a aac -b:a 128k "$output_mp4_optimized"

    # 元のファイルを最適化されたファイルで置き換え
    mv "$output_mp4_optimized" "$video"
  fi
done

echo "Video optimization complete!"
#! /bin/ruby
#`ffmpeg -r 5 -i image.*.jpg -r 5 -vcodec libx264 -crf 20 -g 2 -vf "movie=watermark.png [watermark];[in] crop=1650:800, scale=1650:800 [cropped],[cropped][watermark] overlay=20:20 [out]" timelapse.mp4`

`ffmpeg -f image2 -i image.*.jpg -r 24 -vcodec libx264 -q:v 2 timelapse.mp4`

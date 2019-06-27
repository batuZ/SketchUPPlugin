:: 获取设备
ffmpeg -list_devices true -f dshow -i dummy
::	DirectShow video devices "screen-capture-recorder"
::	DirectShow audio devices "virtual-audio-capturer"


:: 捕获音\视频，默认设置
ffmpeg -f dshow -i video="screen-capture-recorder" v-out.mp4
ffmpeg -f dshow -i audio="virtual-audio-capturer" a-out.aac
ffmpeg -f dshow -i video="screen-capture-recorder":audio="virtual-audio-capturer" av-out.mp4

:: 查看视频\音频可选项
ffmpeg -f dshow -list_options true -i video="screen-capture-recorder"
ffmpeg -f dshow -list_options true -i audio="virtual-audio-capturer"

::配置捕获选项
ffmpeg -f dshow -i -video_size 1920x1200 -framerate 30 -pixel_format yuv420p -i video="screen-capture-recorder" test.mp4
																		

参考资料 https://blog.csdn.net/juedno/article/details/80731733
全屏录像 ( dshow录屏, H264编码 )
ffmpeg -f dshow -i video="screen-capture-recorder" -f dshow -i audio="virtual-audio-capturer" -vcodec libx264 -acodec libmp3lame -s 1280x720 -r 15 e:/temp/temp.mkv
--------------------- 
全屏录像 ( gdigrab录屏, H264编码 )
ffmpeg -f gdigrab -i desktop -f dshow -i audio="virtual-audio-capturer" -vcodec libx264 -acodec libmp3lame -s 1280x720 -r 15 e:/temp/temp.mkv
--------------------- 
全屏录像 ( gdigrab录屏, vp9编码 )( 注 : dshow不支持vp9 )
ffmpeg -f gdigrab -i desktop -f dshow -i audio="virtual-audio-capturer" -vcodec libvpx-vp9 -acodec libmp3lame -s 1280x720 -r 15 e:/temp/temp.mk
--------------------- 
区域录像 ( 起点:100,60 width:600 width:480 )
ffmpeg -f gdigrab -i desktop -f dshow -i audio="virtual-audio-capturer" -vcodec libx264 -acodec libmp3lame -video_size 600x480 -offset_x 100 -offset_y 60 -r 15 e:/temp/temp.mkv
--------------------- 


https://blog.csdn.net/leixiaohua1020/article/details/38284961
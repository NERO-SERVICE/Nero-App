import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/health/model/video_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final VideoData video;

  VideoPlayerPage({required this.video});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  double _downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    // 저장할 파일 경로 생성
    final directory = await getApplicationDocumentsDirectory();
    final videosDir = Directory('${directory.path}/videos');
    if (!await videosDir.exists()) {
      await videosDir.create(recursive: true);
    }

    final filePath = '${videosDir.path}/${widget.video.fileNm}';

    final file = File(filePath);

    if (await file.exists()) {
      // 로컬에 파일이 있으면 그 파일로 동영상 플레이어 초기화
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {
            _initialized = true;
          });
          _controller.play();
        });
    } else {
      // 파일이 없으면 다운로드
      try {
        final dio = Dio();

        setState(() {
          _initialized = false;
          _downloadProgress = 0.0;
        });

        String videoUrl = widget.video.fileUrl + widget.video.fileNm;

        await dio.download(
          videoUrl,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                _downloadProgress = received / total;
              });
            }
          },
        );

        // 다운로드 후 동영상 플레이어 초기화
        _controller = VideoPlayerController.file(file)
          ..initialize().then((_) {
            setState(() {
              _initialized = true;
            });
            _controller.play();
          });
      } catch (e) {
        print('동영상 다운로드 오류: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('동영상을 불러오는데 실패했습니다.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Scaffold(
        appBar: CustomDetailAppBar(title: widget.video.vdoTtlNm),
        body: Center(
          child: _downloadProgress > 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(value: _downloadProgress),
                    SizedBox(height: 20),
                    Text(
                      '다운로드 중... ${(_downloadProgress * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: AppColors.titleColor,
                      ),
                    ),
                  ],
                )
              : CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: CustomDetailAppBar(title: widget.video.vdoTtlNm),
      body: Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}

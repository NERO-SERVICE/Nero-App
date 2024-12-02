import 'package:flutter/material.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/health/controller/health_controller.dart';
import 'package:nero_app/develop/health/model/video_data.dart';
import 'package:nero_app/develop/health/page/video_player_page.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HealthVideoPage extends StatefulWidget {
  @override
  _HealthVideoPageState createState() => _HealthVideoPageState();
}

class _HealthVideoPageState extends State<HealthVideoPage> {
  @override
  void initState() {
    super.initState();
    // 페이지가 로드될 때 동영상 데이터 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HealthController>(context, listen: false).fetchVideoData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return Scaffold(
            appBar: CustomDetailAppBar(title: '운동 동영상'),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (controller.error != null) {
          return Scaffold(
            appBar: CustomDetailAppBar(title: '운동 동영상'),
            body: Center(child: Text(controller.error!)),
          );
        } else {
          final videos = controller.videos;
          return Scaffold(
            appBar: CustomDetailAppBar(title: '운동 동영상'),
            body: ListView.builder(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                VideoData video = videos[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerPage(video: video),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.inactiveButtonColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // 이미지 부분
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl: video.imgFileUrl + video.imgFileNm,
                              placeholder: (context, url) => Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          // 텍스트 부분
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video.vdoTtlNm,
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: AppColors.titleColor,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    video.vdoDesc,
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: AppColors.primaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

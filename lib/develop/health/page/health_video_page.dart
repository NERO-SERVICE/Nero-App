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
  final List<String> sportsSteps = ['준비운동', '본운동', '마무리운동'];
  String selectedSportsStep = '준비운동'; // 기본값

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 페이지가 로드될 때 기본 추천 동영상 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller =
      Provider.of<HealthController>(context, listen: false);
      controller.selectedSportsStep = selectedSportsStep;
      controller.fetchRecommendedVideos();
    });

    _scrollController.addListener(() {
      final controller = Provider.of<HealthController>(context, listen: false);
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !controller.isLoading &&
          controller.hasMore) {
        controller.fetchRecommendedVideos(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: CustomDetailAppBar(title: '추천 운동 동영상'),
          body: Column(
            children: [
              // 운동 단계 선택 드롭다운
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<String>(
                  value: controller.selectedSportsStep,
                  decoration: InputDecoration(
                    labelText: '운동 단계 선택',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  items: sportsSteps
                      .map(
                        (step) => DropdownMenuItem(
                      value: step,
                      child: Text(step),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedSportsStep = value;
                    }
                  },
                ),
              ),
              Expanded(
                child: _buildContent(controller),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(HealthController controller) {
    if (controller.isLoading && controller.recommendedVideos.isEmpty) {
      // 초기 로딩 상태
      return Center(child: CircularProgressIndicator());
    } else if (controller.error != null) {
      // 에러 상태
      return Center(child: Text(controller.error!));
    } else if (controller.recommendedVideos.isEmpty) {
      // 데이터 없음 상태
      return Center(child: Text('추천 동영상이 없습니다.'));
    } else {
      final videos = controller.recommendedVideos;
      return ListView.builder(
        controller: _scrollController,
        padding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: videos.length + 1, // 추가 아이템을 위해 +1
        itemBuilder: (context, index) {
          if (index < videos.length) {
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
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16),
                      // 텍스트 부분
                      Expanded(
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 16),
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
          } else {
            // 로딩 아이콘 표시 (추가 데이터 로딩 중) 또는 모든 데이터 로드 완료 메시지
            if (controller.hasMore) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: Text('모든 동영상을 불러왔습니다.')),
              );
            }
          }
        },
      );
    }
  }
}

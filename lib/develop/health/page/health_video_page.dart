import 'package:flutter/material.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/health/controller/health_controller.dart';
import 'package:nero_app/develop/health/model/video_data.dart';
import 'package:nero_app/develop/health/page/video_player_page.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class HealthVideoPage extends StatefulWidget {
  final String sportsStep;

  const HealthVideoPage({Key? key, required this.sportsStep}) : super(key: key);

  @override
  _HealthVideoPageState createState() => _HealthVideoPageState();
}

class _HealthVideoPageState extends State<HealthVideoPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<HealthController>(context, listen: false);
      controller.selectedSportsStep = widget.sportsStep;
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


  String _truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
  }

  Widget _healthVideoTitle({required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xffD9D9D9),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: CustomDetailAppBar(title: '${widget.sportsStep} 추천 영상'),
          body: _buildContent(controller),
        );
      },
    );
  }

  Widget _buildContent(HealthController controller) {
    if (controller.isLoading && controller.recommendedVideos.isEmpty) {
      // Initial loading state
      return Center(child: CustomLoadingIndicator());
    } else if (controller.error != null) {
      // Error state
      return Center(child: Text(controller.error!));
    } else if (controller.recommendedVideos.isEmpty) {
      // No data state
      return Center(child: Text('추천 동영상이 없습니다.'));
    } else {
      final videos = controller.recommendedVideos;
      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: videos.length + 2, // +1 for header, +1 for loading/all loaded
        itemBuilder: (context, index) {
          if (index == 0) {
            return _healthVideoTitle(
              content: 'AI가 추천해주는 동영상으로\n건강한 습관을 만들어요',
            );
          } else if (index <= videos.length) {
            VideoData video = videos[index - 1];

            String truncatedTitle = _truncateWithEllipsis(15, video.vdoTtlNm);
            String truncatedDesc = _truncateWithEllipsis(45, video.vdoDesc);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 16),
                  child: Text(
                    '추천 $index',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.titleColor,
                    ),
                  ),
                ),
                // Video item
                GestureDetector(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Container
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: video.imgFileUrl + video.imgFileNm,
                            fit: BoxFit.cover,
                            width: 120, // Fixed width
                            height: 120, // Fixed height
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                              ),
                              child: Icon(
                                Icons.error,
                                size: 40,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        // Text Content
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 16, bottom: 16, right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  truncatedTitle,
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: AppColors.titleColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  truncatedDesc,
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: AppColors.primaryTextColor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Loading indicator or all loaded message
            if (controller.hasMore) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CustomLoadingIndicator()),
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

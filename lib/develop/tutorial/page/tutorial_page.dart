import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TutorialPage extends StatefulWidget {
  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isButtonActive = false;

  final List<String> tutorialImages = [
    'assets/develop/tutorial-1.png',
    'assets/develop/tutorial-2.png',
    'assets/develop/tutorial-3.png',
    'assets/develop/tutorial-4.png',
    'assets/develop/tutorial-5.png',
    'assets/develop/tutorial-6.png',
    'assets/develop/tutorial-7.png',
  ];

  final List<String> tutorialTitles = [
    '데일리 복용 체크',
    '지난 진료 기록',
    '하루 설문',
    '부작용 설문',
    '빠른 메모',
    '연간 관리',
    '생리 주기',
  ];

  final List<String> tutorialContents = [
    '지난 진료에서 처방받은 약을\n매일 얼마나 먹는지 고민하지 마세요',
    '병원의 기록은 만성 질환을 관리하는\n가장 기본적인 시작이에요',
    '평소와 다른 점은 없었는지 기록하는\n작은 발걸음이 모여\n나라는 사람을 만들어가요',
    '대수롭지 않게 넘긴 작은 부작용은\n내 몸이 보내는 신호일 수 있어요',
    '준비물, 과제, 약속, 심부름 어떤 사소한 것이라도\n날짜별로 채팅처럼 빠르게 기록해봐요',
    '지난 1년동안 약을 안먹은 날은 언제인지\n부작용이 생긴 날은 언제인지 한 눈에 확인해요',
    '호르몬 변화는 알 수 없는 부작용의\n원인이 될 수 있어요',
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      if (_currentPage == tutorialImages.length - 1) {
        _isButtonActive = true;
      }
    });
  }

  Future<void> _onNextPressed() async {
    Get.offNamed('/home');
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(tutorialImages.length, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: _currentPage == index ? 32 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Color(0xffD0EE17)
                : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 137),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: tutorialImages.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 40),
                        Image.asset(
                          tutorialImages[index],
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 45),
                        Text(
                          tutorialTitles[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 28,
                            color: Color(0xffFFFFFF),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          tutorialContents[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xffFFFFFF),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 187,
            left: 0,
            right: 0,
            child: _buildIndicator(),
          ),
          Positioned(
            bottom: 54,
            left: 32,
            right: 32,
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isButtonActive
                    ? () async {
                  await _onNextPressed();
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: _isButtonActive
                      ? Color(0xffD0EE17).withOpacity(0.5)
                      : Color(0xff3C3C3C),
                  foregroundColor:
                  _isButtonActive ? Color(0xffFFFFFF) : Color(0xffD9D9D9),
                  disabledBackgroundColor: Color(0xff3C3C3C),
                  disabledForegroundColor: Color(0xffD9D9D9),
                  side: BorderSide(
                    color: _isButtonActive
                        ? Color(0xffD0EE17)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Text(
                  '시작하기',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:nero_app/src/common/components/btn.dart';

import 'app_font.dart';
import 'place_name_popup.dart';

class TradeLocationMap extends StatefulWidget {
  final String? lable;
  final LatLng? location;

  const TradeLocationMap({
    super.key,
    this.lable,
    this.location,
  });

  @override
  State<TradeLocationMap> createState() => _TradeLocationMapState();
}

class _TradeLocationMapState extends State<TradeLocationMap> {
  final _mapController = MapController();
  String lable = '';
  LatLng? location;

  @override
  void initState() {
    super.initState();
    lable = widget.lable ?? '';
    location = widget.location;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff212123),
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: Get.back,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset('assets/svg/icons/back.svg'),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '진료 위치',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: Color(0xffFFFFFF),
                  ),
                ),
                SizedBox(height: 13),
                Text(
                  '어디에서 진료받으셨어요?\n위치를 골라주세요',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Color(0xffFFFFFF),
                  ),
                ),
                SizedBox(height: 44),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<Position>(
              future: _determinePosition(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var myLocation =
                  LatLng(snapshot.data!.latitude, snapshot.data!.longitude);
                  if (location != null) {
                    myLocation = location!;
                  }
                  return FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: myLocation,
                      interactiveFlags:
                      InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      onPositionChanged: (position, hasGesture) {
                        if (hasGesture) {
                          setState(() {
                            lable = '';
                          });
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      ),
                    ],
                    nonRotatedChildren: [
                      if (lable != '')
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 7,
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color:
                                  const Color.fromARGB(255, 208, 208, 208),
                                ),
                                child: AppFont(
                                  lable,
                                  color: Colors.black,
                                  size: 12,
                                ),
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      Center(
                        child: SvgPicture.asset(
                          'assets/svg/icons/want_location_marker.svg',
                          width: 45,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: Get.mediaQuery.padding.bottom),
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: // TradeLocationMap 위젯에서 결과를 반환하는 부분
                              ElevatedButton(
                                onPressed: () async {
                                  var result = await Get.dialog<String>(
                                    useSafeArea: false,
                                    PlaceNamePopup(),
                                  );
                                  Get.back(result: {
                                    'label': result,
                                    'location': {
                                      'latitude': _mapController.center.latitude,
                                      'longitude': _mapController.center.longitude,
                                    },
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff1C1B1B),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 66.0),
                                ),
                                child: Text(
                                  '선택 완료',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25,
                                    color: Color(0xffD0EE17),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: Get.mediaQuery.padding.bottom + 30),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xff212123),
          child: Icon(Icons.location_searching),
        ),
      ),
    );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('위치 서비스가 비활성화되었습니다.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('위치 권한이 거부되었습니다.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('위치 권한이 영구적으로 거부되어 권한을 요청할 수 없습니다.');
  }

  return await Geolocator.getCurrentPosition();
}

class SimpleTradeLocationMap extends StatelessWidget {
  // 경량화된 지도
  final String? lable;
  final LatLng myLocation;
  final int interactiveFlags;

  const SimpleTradeLocationMap(
      {super.key,
        required this.myLocation,
        this.lable,
        this.interactiveFlags =
        InteractiveFlag.pinchZoom | InteractiveFlag.drag});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: myLocation,
        interactiveFlags: interactiveFlags,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
      ],
      nonRotatedChildren: [
        if (lable != '')
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: const Color.fromARGB(255, 208, 208, 208),
                  ),
                  child: AppFont(
                    lable!,
                    color: Colors.black,
                    size: 12,
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        Center(
          child: SvgPicture.asset(
            'assets/svg/icons/location_mark.svg',
            height: 45,
            width: 45,
          ),
        ),
      ],
    );
  }
}

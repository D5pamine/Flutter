import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'CustomCard.dart';

class Moviecard extends StatelessWidget {
  final VideoPlayerController controllers;
  final String reportcontent, reporttime, reportreason, reportlocation, reportdate;
  final Color cardLineColor;

  const Moviecard({Key? key,
    required this.controllers,
    required this.reportcontent,
    required this.reportlocation,
    required this.reportreason,
    required this.reporttime,
    required this.reportdate,
    this.cardLineColor=Colors.white
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      cardLineColor: cardLineColor,
      cardBoarderR: const BorderRadius.all(Radius.circular(30)),
      child:
      Row(
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10), // ✅ 둥근 모서리 적용
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 90,  // ✅ 비디오 개별 높이 지정
                            child: AspectRatio(
                              aspectRatio:  18 / 12,
                              child: VideoPlayer(controllers),  // ✅ 각 비디오 컨트롤러 사용
                            ),
                          ),
                          Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                              ),
                          ),
                          const Positioned(
                              top: 40,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Text(
                                  "신고 완료",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text(reportdate, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                  // const Text('마포대교', style: TextStyle(fontSize: 13, color: Color(0xff3C3C3C)),),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning, size: 18,),
                        SizedBox(width: 5,),
                        Text('위반 내용', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 135,
                      child: Text(reportcontent, style: const TextStyle(fontSize: 8, color: Color(0xff696969)),),
                    ),
                    const SizedBox(height: 5,),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on, size: 18,),
                        SizedBox(width: 5,),
                        Text('위반 장소', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10),),
                      ],
                    ),
                    SizedBox(
                      width: 135,
                      child: Text(reportlocation, style: TextStyle(fontSize: 8, color: Color(0xff696969)),),
                    ),
                    const SizedBox(height: 5,),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.help_center, size: 18,),
                        SizedBox(width: 5,),
                        Text('법적 근거', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10),),
                      ],
                    ),
                    SizedBox(
                      width: 135,
                      child: Text(reportreason, style: const TextStyle(fontSize: 8, color: Color(0xff696969)),),
                    ),
                    const SizedBox(height: 5,),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.watch_later, size: 18,),
                        SizedBox(width: 5,),
                        Text('위반 시간', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10),),
                      ],
                    ),
                    SizedBox(
                      width: 135,
                      child: Text(reporttime, style: const TextStyle(fontSize: 8, color: Color(0xff696969)),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
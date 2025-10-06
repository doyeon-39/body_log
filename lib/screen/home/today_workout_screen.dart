import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TodayWorkoutScreen extends StatelessWidget {
  final String name;
  final int? count;
  final int calories;
  final int accuracy;
  final String date;

  const TodayWorkoutScreen({
    super.key,
    required this.name,
    this.count,
    required this.calories,
    required this.accuracy,
    required this.date,
  });

  String getImagePath(String exercise) {
    switch (exercise) {
      case '스쿼트':
        return 'assets/squat.png';
      case '푸쉬업':
        return 'assets/pushup.png';
      case '풀업':
        return 'assets/pullup.png';
      case '점핑잭':
        return 'assets/jumping_jack.png';
      default:
        return 'assets/default.png';
    }
  }


  String _countLabel() {
    if (count == null) return '-';
    return '${count}회';
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = getImagePath(name);
    final percent = (accuracy.clamp(0, 100)) / 100.0;

    return Scaffold(
      backgroundColor: const Color(0xFFAED9A5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('오늘의 운동', style: TextStyle(color: Colors.black)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          } else if (index == 1) {
            Navigator.pushNamedAndRemoveUntil(context, '/video_upload', (route) => false);
          } else if (index == 2) {
            Navigator.pushNamedAndRemoveUntil(context, '/history', (route) => false);
          } else if (index == 3) {
            Navigator.pushNamedAndRemoveUntil(context, '/settings', (route) => false);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.ondemand_video), label: '영상'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: '기록'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ), // ← 여기 쉼표 후 Scaffold의 다음 파라미터로 계속
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 상단 요약 카드
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFDFF0D8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Image.asset(imagePath, width: 60, height: 60),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 예: "스쿼트 20회" / "플랭크 -"
                          Text(
                            '$name ${_countLabel()}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text('🔥 칼로리 소모: $calories kcal'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 분석 카드
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: const Color(0xFFDFF0D8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$name 분석 결과', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 동일 규칙 사용
                                Text('$name ${_countLabel()}'),
                                Text('🔥 칼로리 소모: $calories kcal'),
                              ],
                            ),
                          ),
                          CircularPercentIndicator(
                            radius: 35.0,
                            lineWidth: 6.0,
                            percent: percent,
                            center: Text('$accuracy%', style: const TextStyle(fontWeight: FontWeight.bold)),
                            progressColor: Colors.green,
                            backgroundColor: Colors.grey.shade300,
                          ),
                          const SizedBox(width: 8),
                          const Text('올바른 자세 비율'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text('저장하기', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

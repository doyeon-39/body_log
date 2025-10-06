import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VideoAnalysisScreen extends StatefulWidget {
  final File videoFile;
  final String exercise;
  final int count;
  final int calories;

  const VideoAnalysisScreen({
    super.key,
    required this.videoFile,
    required this.exercise,
    required this.count,
    required this.calories,
  });

  @override
  _VideoAnalysisScreenState createState() => _VideoAnalysisScreenState();
}

class _VideoAnalysisScreenState extends State<VideoAnalysisScreen> {
  late VlcPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VlcPlayerController.file(
      widget.videoFile,
      hwAcc: HwAcc.full,
      autoPlay: false,
      options: VlcPlayerOptions(),
    );
    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      await _controller.initialize();
      if (mounted) setState(() {});
    } catch (error) {
      // 오류 표시
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("VLC 초기화 오류: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 동기 분석: 결과 이미 확보됨 → 즉시 결과 렌더
    return Scaffold(
      appBar: AppBar(title: const Text('분석 결과')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 영상 미리보기
            FutureBuilder(
              future: _controller.initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SizedBox(
                  height: 200,
                  child: VlcPlayer(
                    controller: _controller,
                    aspectRatio: 16 / 9,
                    virtualDisplay: true,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // === 분석 결과 (즉시 표시) ===
            Text('${widget.exercise} ${widget.count}회'),
            Text('🔥 약 ${widget.calories} kcal'),
            const SizedBox(height: 16),

            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('저장하기', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

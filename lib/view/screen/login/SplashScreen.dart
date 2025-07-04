import 'package:flutter/material.dart';
import 'package:medilink/view/screen/login/LoginScreen.dart';
import 'package:medilink/view/widget/login/HeartbeatAudioController.dart';
import 'package:medilink/view/widget/login/animated_logo.dart';
import 'package:medilink/view/widget/login/app_name_text.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:medilink/view/widget/login/splash_background.dart'; // ← استيراد الصوت

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _fadeOutController;

  late final Animation<double> _logoAnimation;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _fadeOut;
  final HeartbeatAudioController _heartbeatController =
      HeartbeatAudioController();

  @override
  void initState() {
    super.initState();

    _setupAnimations();
    _startTimers();
    _heartbeatController.start(); // ← تشغيل الصوت
    _startTimers();
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _logoAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _textFade = Tween<double>(begin: 0, end: 1).animate(_textController);
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeOut = Tween<double>(begin: 1, end: 0).animate(_fadeOutController);
  }

  void _startTimers() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      _textController.forward();
    });

    Future.delayed(const Duration(milliseconds: 5000), () async {
      await _fadeOutController.forward();
      await _heartbeatController.stop(); // ← إيقاف الصوت
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeOut,
      child: SplashBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedLogo(animation: _logoAnimation),
            const SizedBox(height: 25),
            AppNameText(fadeAnimation: _textFade, slideAnimation: _textSlide),
          ],
        ),
      ),
    );
  }
}

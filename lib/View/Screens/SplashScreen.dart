import 'package:flutter/material.dart';
import 'package:medilink/View/Screens/LoginScreen.dart';
import 'package:medilink/Widgets/animated_logo.dart';
import 'package:medilink/Widgets/app_name_text.dart';
import 'package:medilink/Widgets/splash_background.dart';

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

  @override
  void initState() {
    super.initState();

    _setupAnimations();
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

    Future.delayed(const Duration(milliseconds: 3500), () {
      _fadeOutController.forward().then((_) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      });
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

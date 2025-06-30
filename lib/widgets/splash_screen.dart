import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showTagline = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Delay showing the tagline for a smoother appearance
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showTagline = true;
        });
      }
    });

    // Navigate to home screen after a delay
    Future.delayed(const Duration(seconds: 5), () {
      // In a real app, you would navigate to your home screen here
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => HomeScreen()),
      // );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade50,
              Colors.orange.shade100,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: -20,
              right: -20,
              child: Opacity(
                opacity: 0.2,
                child: Icon(
                  Icons.restaurant,
                  size: 150,
                  color: Colors.orange.shade900,
                ),
              ),
            ),
            Positioned(
              bottom: -10,
              left: -10,
              child: Opacity(
                opacity: 0.2,
                child: Icon(
                  Icons.local_cafe,
                  size: 120,
                  color: Colors.orange.shade800,
                ),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated cooking pot
                  SizedBox(
                    height: 180,
                    width: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Pot
                        Container(
                          height: 120,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(70),
                              bottomRight: Radius.circular(70),
                            ),
                          ),
                        ),

                        // Pot lid
                        Positioned(
                          top: 30,
                          child: Container(
                            height: 25,
                            width: 160,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade700,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(80),
                                topRight: Radius.circular(80),
                              ),
                            ),
                          ),
                        ),

                        // Lid handle
                        Positioned(
                          top: 20,
                          child: Container(
                            height: 15,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade600,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                        // Steam animations
                        Positioned(
                          top: 5,
                          left: 50,
                          child: AnimatedSteam(
                            controller: _controller,
                            offset: 0,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          child: AnimatedSteam(
                            controller: _controller,
                            offset: 0.3,
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 50,
                          child: AnimatedSteam(
                            controller: _controller,
                            offset: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // App name with animated shadow
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: Text(
                            "Recipify",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade900,
                              shadows: [
                                Shadow(
                                  color: Colors.orange.shade200,
                                  blurRadius: 10 * value,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Animated tagline
                  AnimatedOpacity(
                    opacity: _showTagline ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      "Your smart cooking assistant",
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Loading indicator
                  SizedBox(
                    width: 180,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.orange.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.orange.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom animated steam widget
class AnimatedSteam extends StatelessWidget {
  final AnimationController controller;
  final double offset;

  const AnimatedSteam({
    Key? key,
    required this.controller,
    required this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final double value = ((controller.value + offset) % 1.0);
        return Opacity(
          opacity: (1.0 - value),
          child: Transform.translate(
            offset: Offset(
              math.sin((value) * math.pi * 2) * 8,
              -40 * value,
            ),
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }
}

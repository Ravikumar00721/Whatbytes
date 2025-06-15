import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  double _scale = 0.8;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showError = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });

    Timer(const Duration(seconds: 3), () {
      final user = FirebaseAuth.instance.currentUser;
      context.go(user != null ? '/home' : '/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFFFF3E0)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: _scale,
                duration: const Duration(seconds: 1),
                curve: Curves.elasticOut,
                child: ScaleTransition(
                  scale: _animation,
                  child: _showError
                      ? const Icon(
                          Icons.error_outline,
                          size: 100,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.content_copy,
                          size: 100,
                          color: Colors.orange,
                        ),
                ),
              ),
              const SizedBox(height: 30),
              AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: _opacity,
                child: Text(
                  "WhatBytes",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).primaryColor,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 1500),
                child: const Text(
                  "Manage You Tasks",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 1000),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              if (_showError)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Configuration issue detected",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

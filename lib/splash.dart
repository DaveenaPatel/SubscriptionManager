import 'package:flutter/material.dart';
import 'registration.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/wallet.png', width: 100),
            const SizedBox(height: 24),
            const Text(
              'SubWallet',
              style: TextStyle(
                fontFamily: 'Syne',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.lightGreen,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: Colors.lightGreen),
            const SizedBox(height: 12),
            const Text('Loading', style: TextStyle(color: Colors.lightGreen)),
          ],
        ),
      ),
    );
  }
}
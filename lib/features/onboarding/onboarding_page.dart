
import 'package:flutter/material.dart';
import 'package:vibe_connect/features/auth/presentation/ui/login_page.dart';
import 'package:vibe_connect/features/auth/presentation/ui/register_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App icon
              SizedBox(
                width: 250,
                height: 250,
                child: Image.asset(
                  'assets/images/video.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 3),
              // Main title
              Text(
                'ONE APP TO TURN\nYOUR IDEAS INTO\nVIDEOS\nINSTANTLY.', 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  letterSpacing: 0.5,
                  height: 1.25,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 50),
              // Log in and Register buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB18AFF),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          textStyle: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        child: const Text('Log in'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB18AFF),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          textStyle: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        child: const Text('Register'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Divider with OR
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: Color(0xFF35313F),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.7),
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color: Color(0xFF35313F),
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Continue as Guest button
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement continue as guest
                  },
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Image.asset(
                      'assets/images/ghost-linear.png',
                      width: 22,
                      height: 22,
                    ),
                  ),
                  label: const Text(
                    'Continue as a Guest',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                    side: const BorderSide(
                      color: Color(0xFF23202A),
                      width: 1.5,
                    ),
                    backgroundColor: const Color(0xFF18151F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
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

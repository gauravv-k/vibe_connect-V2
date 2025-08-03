
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibe_connect/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:vibe_connect/features/auth/presentation/cubits/auth_states.dart';
import 'package:vibe_connect/features/onboarding/onboarding_page.dart';
import 'package:vibe_connect/features/rootscreen/rootpage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    
    print('🎯 SplashPage: initState called');
    
    // Check initial auth state
    final authCubit = context.read<AuthCubit>();
    print('🎯 SplashPage: Initial auth state: ${authCubit.state.runtimeType}');
    
    // Initialize animation controllers with longer duration for 5-second display
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000), // Increased duration
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1500), // Increased duration
      vsync: this,
    );
    
    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    // Start animations with proper timing
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _slideController.forward();
      }
    });
    
    // Ensure splash screen displays for exactly 4.5 seconds regardless of auth state
    // This ensures consistent behavior on app restart and prevents getting stuck in loading states
    Future.delayed(const Duration(milliseconds: 4500), () {
      if (mounted && !_hasNavigated) {
        print('🎯 SplashPage: 4.5 seconds elapsed, checking auth state and navigating');
        _checkAuthAndNavigate();
      }
    });
  }

  void _checkAuthAndNavigate() {
    if (_hasNavigated) return;
    
    final authCubit = context.read<AuthCubit>();
    final currentState = authCubit.state;
    
    print('🎯 SplashPage: _checkAuthAndNavigate called, state: ${currentState.runtimeType}');
    
    // Always navigate after 4.5 seconds, regardless of loading state
    // This ensures the splash screen doesn't get stuck on app restart
    print('🎯 SplashPage: Navigating after 4.5 seconds...');
    _hasNavigated = true;
    
    // Fade out animation before navigation
    _fadeController.reverse().then((_) {
      if (mounted) {
        if (currentState is Authenticated) {
          print('🎯 SplashPage: Navigating to RootPage');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const RootPage()),
          );
        } else {
          print('🎯 SplashPage: Navigating to OnboardingPage');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnboardingPage()),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocListener<AuthCubit, AuthStates>(
        listener: (context, state) {
          // Listen for auth state changes and navigate accordingly
          print('🎯 SplashPage: Auth state changed to: ${state.runtimeType}');
          // Only navigate if we get a final auth state (not loading) and haven't navigated yet
          if ((state is Authenticated || state is Unauthenticated) && !_hasNavigated) {
            print('🎯 SplashPage: Auth state is Authenticated or Unauthenticated, but waiting for 4.5 seconds to complete');
            // Don't call _checkAuthAndNavigate here - let the timer handle it
            // This ensures the splash screen always displays for the full 4.5 seconds
          }
        },
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 197, // Smaller width
                  height: 197, // Smaller height
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 40), // Vertical spacing between logo and title

                // Animated main title "DeepVid" with slide animation
                SlideTransition(
                  position: _slideAnimation,
                  child: Text(
                    'DeepVid',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF9066B8),
                      fontFamily: 'Urbanist',
                      height: 1.0, // 100% line height
                      letterSpacing: 0.0, // 0% letter spacing
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 8), // Smaller spacing between title and subtitle

                // Animated subtitle "AI Faceless Video Generator" with slide animation
                SlideTransition(
                  position: _slideAnimation,
                  child: Text(
                    'AI Faceless Video Generator',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

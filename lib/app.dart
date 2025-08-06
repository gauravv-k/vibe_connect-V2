import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibe_connect/features/ai_meet/bloc/meeting_bloc.dart';
import 'package:vibe_connect/features/auth/data/firebase_auth_repo.dart';
import 'package:vibe_connect/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:vibe_connect/features/auth/presentation/cubits/auth_states.dart';
import 'package:vibe_connect/features/onboarding/splash_page.dart';
import 'package:vibe_connect/features/profile/data/firebase_profile_repo.dart';
import 'package:vibe_connect/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:vibe_connect/features/storage/bloc/storage_bloc.dart';
import 'package:vibe_connect/features/themes/cubit/theme_cubit.dart';

/*
APP Root Level
Repositories: for the database
-firebase

Bloc Providers: for state management
-auth
-profile
-meeting
-theme



Check Auth State
-unauthenticated -> onboarding page
-authenticated -> home page
-loading -> circular progress indicator
*/
class MyApp extends StatelessWidget {
  //auth repo
  final firebaseAuthRepo = FirebaseAuthRepo();
  //profile repo
  final firebaseProfileRepo = FirebaseProfileRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          //auth cubit
          BlocProvider<AuthCubit>(
            create: (context) =>
                AuthCubit(authRepo: firebaseAuthRepo)..checkCurrentUser(),
          ),
          //theme cubit
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(),
          ),
          //profile cubit
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(profileRepo: firebaseProfileRepo),
          ),
          // meeting bloc
          BlocProvider(
            create: (context) => MeetingBloc(),
          ),
          //Storage Provider
          BlocProvider(
            create: (context) => StorageBloc(),
          ), 
          
        ], // theme builder
        child: BlocBuilder<ThemeCubit, ThemeData>(
          builder: (context, currentTheme) => MaterialApp(
            theme: currentTheme,
            debugShowCheckedModeBanner: false,
            home: ScaffoldMessenger(
              child: BlocConsumer<AuthCubit, AuthStates>(
                listener: (context, state) {
                  if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  // Always show splash page first
                  return const SplashPage();
                },
              ),
            ),
          ),
        ));
  }
}

// This is the main entry point of the application.
// It initializes Firebase and Hive, and sets up the BLoC provider for the MeetingBloc.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vibe_connect/app.dart';
import 'package:vibe_connect/features/ai_meet/bloc/meeting_bloc.dart';

import 'package:vibe_connect/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( MyApp());
}

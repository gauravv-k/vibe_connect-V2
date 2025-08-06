
// This file contains the business logic for the meeting feature.
// It handles events such as starting, ending, and saving a meeting.
// It also manages the meeting data, including the title, transcription, and image paths.

import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

part 'meeting_event.dart';
part 'meeting_state.dart';

class MeetingBloc extends Bloc<MeetingEvent, MeetingState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MeetingBloc() : super(MeetingInitial()) {
    on<StartMeeting>(_onStartMeeting);
    on<UpdateTranscription>(_onUpdateTranscription);
    on<AddImagePath>(_onAddImagePath);
    on<EndMeeting>(_onEndMeeting);
    on<SaveMeeting>(_onSaveMeeting);
  }

  Future<void> _onStartMeeting(
      StartMeeting event, Emitter<MeetingState> emit) async {
    try {
      var box = await Hive.openBox('meeting_data');
      await box.put('meetingId', event.meetingId);
      await box.put('title', event.title);
      await box.put('createdBy', event.createdBy);
      await box.put('date', DateTime.now().toIso8601String());
      await box.put('transcript', '');
      await box.put('imagePaths', []);
      emit(MeetingInProgress(title: event.title));
    } catch (e) {
      emit(MeetingError(e.toString()));
    }
  }

  Future<void> _onUpdateTranscription(
      UpdateTranscription event, Emitter<MeetingState> emit) async {
    if (state is MeetingInProgress) {
      final currentState = state as MeetingInProgress;
      final newFullTranscription =
          (currentState.transcription + ' ' + event.transcription).trim();
      var box = await Hive.openBox('meeting_data');
      await box.put('transcript', newFullTranscription);
      emit(MeetingInProgress(
        title: currentState.title,
        transcription: newFullTranscription,
        imagePaths: currentState.imagePaths,
      ));
    }
  }

  Future<void> _onAddImagePath(
      AddImagePath event, Emitter<MeetingState> emit) async {
    if (state is MeetingInProgress) {
      final currentState = state as MeetingInProgress;
      var box = await Hive.openBox('meeting_data');
      final imagePaths = List<String>.from(box.get('imagePaths', defaultValue: []));
      imagePaths.add(event.imagePath);
      await box.put('imagePaths', imagePaths);
      emit(MeetingInProgress(
        title: currentState.title,
        transcription: currentState.transcription,
        imagePaths: imagePaths,
      ));
    }
  }

  void _onEndMeeting(EndMeeting event, Emitter<MeetingState> emit) {
    // This event is mostly for UI changes, BLoC doesn't need to do much here.
  }

  Future<void> _onSaveMeeting(
      SaveMeeting event, Emitter<MeetingState> emit) async {
    emit(const MeetingSaving(progress: 0.0));
    try {
      var box = await Hive.openBox('meeting_data');
      final meetingId = box.get('meetingId');
      final title = box.get('title');
      final createdByUid = box.get('createdBy');
      final date = box.get('date');
      final transcript = box.get('transcript');
      final imagePaths = List<String>.from(box.get('imagePaths'));

      final userDoc =
          await _firestore.collection('user').doc(createdByUid).get();
      final createdByName = userDoc.data()?['name'] as String? ?? 'Unknown';

      final imageUrls = await _uploadImages(imagePaths, emit);

      await _firestore.collection('meetings').add({  // firestore
        'meetingId': meetingId,
        'title': title,
        'createdBy': createdByName,
        'date': date,
        'transcript': transcript,
        'imageUrls': imageUrls,
      });

      await _clearHiveCache();
      emit(MeetingSaved());
    } catch (e) {
      emit(MeetingError(e.toString()));
    }
  }

  Future<List<String>> _uploadImages(
      List<String> imagePaths, Emitter<MeetingState> emit) async {
    final List<String> imageUrls = [];
    for (int i = 0; i < imagePaths.length; i++) {
      final imagePath = imagePaths[i];
      final file = File(imagePath);
      final fileName = imagePath.split('/').last;
      final ref = _storage.ref().child('meeting_images/$fileName'); // firebase storage
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
      emit(MeetingSaving(progress: (i + 1) / imagePaths.length));
    }
    return imageUrls;
  }

  Future<void> _clearHiveCache() async {
    var box = await Hive.openBox('meeting_data');
    await box.clear();
    final appDir = await getApplicationDocumentsDirectory();
    final hiveDir = Directory(appDir.path + '/meeting_images');
    if (await hiveDir.exists()) {
      await hiveDir.delete(recursive: true);
    }
  }
}

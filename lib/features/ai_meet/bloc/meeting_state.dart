// This file defines the states that the MeetingBloc can be in.
// These states represent the different stages of the meeting feature, such as initial, in progress, saving, saved, and error.

part of 'meeting_bloc.dart';

abstract class MeetingState extends Equatable {
  const MeetingState();

  @override
  List<Object> get props => [];
}

class MeetingInitial extends MeetingState {}

class MeetingInProgress extends MeetingState {
  final String title;
  final String transcription;
  final List<String> imagePaths;

  const MeetingInProgress({
    required this.title,
    this.transcription = '',
    this.imagePaths = const [],
  });

  @override
  List<Object> get props => [title, transcription, imagePaths];
}

class MeetingSaving extends MeetingState {}

class MeetingSaved extends MeetingState {}

class MeetingError extends MeetingState {
  final String message;

  const MeetingError(this.message);

  @override
  List<Object> get props => [message];
}

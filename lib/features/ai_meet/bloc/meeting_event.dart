// This file defines the events that can be dispatched to the MeetingBloc.
// These events trigger state changes in the meeting feature.

part of 'meeting_bloc.dart';

abstract class MeetingEvent extends Equatable {
  const MeetingEvent();

  @override
  List<Object> get props => [];
}

class StartMeeting extends MeetingEvent {
  final String meetingId;
  final String title;
  final String createdBy;

  const StartMeeting({
    required this.meetingId,
    required this.title,
    required this.createdBy,
  });

  @override
  List<Object> get props => [meetingId, title, createdBy];
}

class UpdateTranscription extends MeetingEvent {
  final String transcription;

  const UpdateTranscription(this.transcription);

  @override
  List<Object> get props => [transcription];
}

class AddImagePath extends MeetingEvent {
  final String imagePath;

  const AddImagePath(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class EndMeeting extends MeetingEvent {}

class SaveMeeting extends MeetingEvent {}

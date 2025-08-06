part of 'storage_bloc.dart';

abstract class StorageEvent extends Equatable {
  const StorageEvent();

  @override
  List<Object> get props => [];
}

class LoadMeetings extends StorageEvent {
  final String userId;

  const LoadMeetings(this.userId);

  @override
  List<Object> get props => [userId];
}

class DeleteMeeting extends StorageEvent {
  final String meetingId;

  const DeleteMeeting(this.meetingId);

  @override
  List<Object> get props => [meetingId];
}
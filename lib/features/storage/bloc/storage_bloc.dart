import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'storage_event.dart';
part 'storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StorageBloc() : super(StorageInitial()) {
    on<LoadMeetings>(_onLoadMeetings);
  }

  void _onLoadMeetings(LoadMeetings event, Emitter<StorageState> emit) {
    emit(StorageLoading());
    try {
      final meetingsStream = _firestore.collection('meetings').snapshots();
      emit(StorageLoaded(meetingsStream));
    } catch (e) {
      emit(StorageError(e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/user_model.dart';
import '../network/api_client.dart';
import '../repositories/student_repository.dart';

// Student States
abstract class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final UserModel user;

  const StudentLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class StudentError extends StudentState {
  final String message;

  const StudentError(this.message);

  @override
  List<Object?> get props => [message];
}

// Student Cubit
class StudentCubit extends Cubit<StudentState> {
  final StudentRepository _studentRepository;

  StudentCubit({StudentRepository? studentRepository})
      : _studentRepository = studentRepository ?? StudentRepository(),
        super(StudentInitial());

  /// Load student dashboard from API
  Future<void> loadDashboard() async {
    emit(StudentLoading());
    try {
      final user = await _studentRepository.getDashboard();
      emit(StudentLoaded(user));
    } on ApiException catch (e) {
      final cachedUser = await _studentRepository.getCachedProfile();
      if (cachedUser != null) {
        emit(StudentLoaded(cachedUser));
      } else {
        emit(StudentError(e.message));
      }
    } catch (e) {
      final cachedUser = await _studentRepository.getCachedProfile();
      if (cachedUser != null) {
        emit(StudentLoaded(cachedUser));
      } else {
        emit(StudentError('Failed to load dashboard: ${e.toString()}'));
      }
    }
  }

  /// Load student profile from API
  Future<void> loadProfile() async {
    emit(StudentLoading());
    try {
      final user = await _studentRepository.getProfile();
      emit(StudentLoaded(user));
    } on ApiException catch (e) {
      final cachedUser = await _studentRepository.getCachedProfile();
      if (cachedUser != null) {
        emit(StudentLoaded(cachedUser));
      } else {
        emit(StudentError(e.message));
      }
    } catch (e) {
      final cachedUser = await _studentRepository.getCachedProfile();
      if (cachedUser != null) {
        emit(StudentLoaded(cachedUser));
      } else {
        emit(StudentError('Failed to load profile: ${e.toString()}'));
      }
    }
  }

  /// Load cached profile (for offline use)
  Future<void> loadCachedProfile() async {
    final cachedUser = await _studentRepository.getCachedProfile();
    if (cachedUser != null) {
      emit(StudentLoaded(cachedUser));
    }
  }

  /// Clear profile data
  void clearProfile() {
    emit(StudentInitial());
  }
}

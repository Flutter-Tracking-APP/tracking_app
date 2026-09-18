import 'dart:async';
 
import 'package:flutter_bloc/flutter_bloc.dart';
 
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/auth/domain/entities/login_entity.dart';
import 'package:tracking_app/features/auth/domain/params/login_params.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_use_case.dart';
import 'login_event.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  // final SessionService _sessionService;

  LoginCubit(this._loginUseCase)
    : super(LoginState.initial());

  final StreamController<LoginUIEvent> _uiEventController =
      StreamController.broadcast();

  Stream<LoginUIEvent> get uiStream => _uiEventController.stream;

  Future<void> doEvent(LoginEvent event) async {
    switch (event) {
      case LoginSubmitted():
        await _login(event);

      case RememberMeChanged():
        await _rememberMeChanged(event);

      case FormValidityChanged():
        await _formValidityChanged(event);

 
    }
  }

  Future<void> _rememberMeChanged(RememberMeChanged event) async {
    emit(state.copyWith(rememberMe: event.value));
  }

  Future<void> _formValidityChanged(FormValidityChanged event) async {
    emit(state.copyWith(isFormValid: event.isValid));
  }

  Future<void> _login(LoginSubmitted event) async {
    if (!state.isFormValid) {
      return;
    }
    emit(
      state.copyWith(
        login: state.login.copyWith(isLoading: true, errorMessage: null),
      ),
    );

    final params = LoginParams(email: event.email, password: event.password);

    final result = await _loginUseCase(params, state.rememberMe);

    switch (result) {
      case Success<LoginEntity>():
        emit(
          state.copyWith(
            login: state.login.copyWith(isLoading: false, data: result.data),
          ),
        );
        _uiEventController.add(ShowMessage('loginSuccessfully'));
        _uiEventController.add(LoginSuccess());

      case Failure<LoginEntity>():
        emit(
          state.copyWith(
            login: state.login.copyWith(
              isLoading: false,
              errorMessage: result.message,
            ),
          ),
        );
        _uiEventController.add(ShowMessage(result.error as String));
    }
  }

 

  @override
  Future<void> close() {
    _uiEventController.close();
    return super.close();
  }
}

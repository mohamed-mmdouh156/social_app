import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Shared/Componant/compontents.dart';
import 'package:social_app/Shared/Cubits/LoginCubit/state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(AppLoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
  var loginModel;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(AppLoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value){
      emit(AppLoginSuccessState(value.user!.uid));
      showToast(text: 'Login Success', state: ToastState.SUCCESS);
    }).catchError((error){
      print('Error when login : ${error.toString()}');
      emit(AppLoginErrorState(error.toString()));
    });
  }

  bool isPass = true;
  IconData sufixIcon = Icons.visibility;

  void changePassword() {
    isPass = !isPass;
    sufixIcon = isPass ? Icons.visibility : Icons.visibility_off;
    emit(AppLoginChangePasswordState());
  }
}

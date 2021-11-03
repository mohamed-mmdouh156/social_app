import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Model/UserModel.dart';
import 'package:social_app/Shared/Cubits/RegisterCubit/state.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(AppRegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);
  var loginModel;

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(AppRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      createUser(
        email: email,
        name: name,
        phone: phone,
        uId: value.user!.uid,
      );
     // emit(AppRegisterSuccessState());
    }).catchError((error) {
      print('Error when Register : ${error.toString()}');
      emit(AppRegisterErrorState(error));
    });
  }

  void createUser({
    required String email,
    required String name,
    required String phone,
    required String uId,
  }) {
    emit(AppRegisterLoadingState());

    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      image: 'https://hips.hearstapps.com/digitalspyuk.cdnds.net/17/13/1490989105-twitter1.jpg',
      cover: 'https://as1.ftcdn.net/v2/jpg/03/02/04/06/1000_F_302040655_IEH9RyDlu7LL8YCLjgL1IskhrpOlmlSv.jpg',
      bio: 'Write your bio....',
      isVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(AppCreateUserSuccessState());
    }).catchError((error) {
      print('Error when Register : ${error.toString()}');
      emit(AppCreateUserErrorState(error.toString()));
    });
  }

  bool isPass = true;
  IconData sufixIcon = Icons.visibility;

  void changePassword() {
    isPass = !isPass;
    sufixIcon = isPass ? Icons.visibility : Icons.visibility_off;
    emit(AppRegisterChangePasswordState());
  }
}

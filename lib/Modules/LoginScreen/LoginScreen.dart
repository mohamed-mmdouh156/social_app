import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Layouts/HomeLayout/Home.dart';
import 'package:social_app/Modules/RegisterScreen/RegisterScreen.dart';
import 'package:social_app/Shared/Componant/compontents.dart';
import 'package:social_app/Shared/Componant/constants.dart';
import 'package:social_app/Shared/Cubits/LoginCubit/cubit.dart';
import 'package:social_app/Shared/Cubits/LoginCubit/state.dart';
import 'package:social_app/Shared/Network/Locate/CacheHelper.dart';
import 'package:social_app/Shared/Style/colors.dart';


class LoginScreen extends StatelessWidget {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit , LoginStates>(
      listener:(context , state){
        if(state is AppLoginErrorState){
          showToast(text: state.error, state: ToastState.ERROR);
        }
        if(state is AppLoginSuccessState) {
            CacheHelper.saveData(
                key:'uId',
                value: state.uId).then((value)
            {
              navigateAndRemove(
                context: context,
                widget: Home(),
              );
            });
        }
      } ,
      builder: (context , state){
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: defaultColor,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Login now to browse our hot offers',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      defaultFormField(
                          lable: 'Email',
                          textController: emailController,
                          prefixIcon: Icons.email_outlined,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'please enter email address';
                            }
                          },
                          textType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                        lable: 'Password',
                        textController: passwordController,
                        prefixIcon: Icons.lock_outline,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Incorrect password';
                          }
                        },
                        isPassword: LoginCubit.get(context).isPass,
                        sufixIcon: LoginCubit.get(context).sufixIcon,
                        sufixPressed: (){
                          LoginCubit.get(context).changePassword();
                        },
                      ), // FormFeild
                      SizedBox(
                        height: 30.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! AppLoginLoadingState,
                        builder: (context)=>Container(
                          width: double.infinity,
                          height: 50.0,
                          child: MaterialButton(
                            onPressed: (){
                              if (formKey.currentState!.validate()){
                                LoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                              return null ;
                            },
                            color: Colors.blue,
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        fallback: (context)=> Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account ?',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          TextButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return RegisterScreen();
                              }));
                            },
                            child: Text(
                              'REGISTER',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 100.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

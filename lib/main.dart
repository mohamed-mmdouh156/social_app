// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Layouts/HomeLayout/Home.dart';
import 'package:social_app/Modules/LoginScreen/LoginScreen.dart';
import 'package:social_app/Shared/Componant/compontents.dart';
import 'package:social_app/Shared/Componant/constants.dart';
import 'package:social_app/Shared/Cubits/MainCubit/cubit.dart';
import 'package:social_app/Shared/Cubits/MainCubit/states.dart';
import 'package:social_app/Shared/Style/themes.dart';

import 'Shared/Cubits/LoginCubit/cubit.dart';
import 'Shared/Cubits/RegisterCubit/cubit.dart';
import 'Shared/Network/Locate/CacheHelper.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  showToast(text: 'on background Message', state: ToastState.SUCCESS);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await CacheHelper.init();

  uId = CacheHelper.getData(key: 'uId');

  var token = await FirebaseMessaging.instance.getToken();

  print(token.toString());
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
    showToast(text: 'on Message', state: ToastState.SUCCESS);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    showToast(text: 'on Opened Message', state: ToastState.SUCCESS);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Widget widget;

  if (uId != null) {
    widget = Home();
  } else {
    widget = LoginScreen();
  }
  runApp(MyApp(
    widget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget widget;

  const MyApp({Key key, this.widget}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => SocialCubit()..getUserData()..getPosts()..getMyPosts(),
        ),
        BlocProvider(
          create: (BuildContext context) => LoginCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => RegisterCubit(),
        ),
      ],
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            title: 'Social App',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            home: widget,
          );
        },
      ),
    );
  }
}

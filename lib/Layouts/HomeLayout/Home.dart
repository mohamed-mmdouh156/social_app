import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Modules/NewPost/NewPost.dart';
import 'package:social_app/Modules/NotificationScreen/NotificationScreen.dart';
import 'package:social_app/Modules/SearchScreen/SearchScreen.dart';
import 'package:social_app/Shared/Componant/compontents.dart';
import 'package:social_app/Shared/Cubits/MainCubit/cubit.dart';
import 'package:social_app/Shared/Cubits/MainCubit/states.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if(state is SocialNewPostState){
          navigateTo(context: context, widget: NewPost());
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            actions: [
              IconButton(
                onPressed: (){
                  navigateTo(context: context, widget: SearchScreen());
                },
                icon: Icon(
                Icons.search,
              ),
              ),
              IconButton(
                onPressed: (){
                  navigateTo(context: context, widget: NotificationScreen());
                },
                icon: Icon(
                  Icons.notifications,
                ),
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.people,
                ),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.note_add,
                ),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.message,
                ),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: 'Profile',
              ),
            ],
            onTap: (index){
              cubit.changeIndex(index);
            },
          ),
        );
      },
    );
  }
}

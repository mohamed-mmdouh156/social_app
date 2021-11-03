import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Model/UserModel.dart';
import 'package:social_app/Modules/ChatRoom/ChatRoom.dart';
import 'package:social_app/Modules/MyUserProfile/MyUserProfile.dart';
import 'package:social_app/Modules/UserProfile/UserProfile.dart';
import 'package:social_app/Shared/Componant/compontents.dart';
import 'package:social_app/Shared/Cubits/MainCubit/cubit.dart';
import 'package:social_app/Shared/Cubits/MainCubit/states.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer <SocialCubit , SocialStates>(
      listener: (context , index){},
      builder: (context , index){
        return ConditionalBuilder(
          condition: SocialCubit.get(context).users.length > 0,
          builder: (context) =>ListView.separated(
            itemBuilder: (context , index) => listItem(SocialCubit.get(context).users[index] , context),
            separatorBuilder: (context , index) => divider(),
            itemCount: SocialCubit.get(context).users.length,
          ),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget listItem(UserModel model , context)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0 , vertical: 15.0),
      child: InkWell(
        onTap: (){
          navigateTo(context: context, widget: MyUserProfile(model: model,));
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 28.0,
              backgroundImage: NetworkImage('${model.image}'),
            ),
            SizedBox(
              width: 15.0,
            ),
            Text(
              '${model.name}',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w900,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget divider ()
  {
    return Container(
      height: 1.0,
      width: double.infinity,
      color: Colors.grey[300],
      margin: EdgeInsets.symmetric(horizontal: 40.0),
    );
  }
}

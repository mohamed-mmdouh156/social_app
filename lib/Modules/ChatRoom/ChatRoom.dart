import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Model/MessageModel.dart';
import 'package:social_app/Model/UserModel.dart';
import 'package:social_app/Shared/Cubits/MainCubit/cubit.dart';
import 'package:social_app/Shared/Cubits/MainCubit/states.dart';

class ChatRoom extends StatelessWidget {

  UserModel? receiverModel;
  var messageController = TextEditingController();
  ChatRoom({this.receiverModel});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessages(
            receiverId: receiverModel!.uId!,
        );
        return BlocConsumer<SocialCubit , SocialStates>(
          listener: (context , state){},
          builder: (context , state){
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage('${receiverModel!.image}'),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      '${receiverModel!.name}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w900,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                        itemBuilder: (context , index){
                          var message = SocialCubit.get(context).messages[index];

                          if(SocialCubit.get(context).userModel!.uId == message.senderId)
                            return myMessageItem(message);
                          else
                            return messageItem(message);
                        },
                        separatorBuilder: (context , index) => SizedBox(
                          height: 1.0,
                        ),
                        itemCount: SocialCubit.get(context).messages.length,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40.0,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 18.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey[200],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Type a message here....',
                                border: InputBorder.none,
                              ),
                              controller: messageController,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            SocialCubit.get(context).sendMessage(
                              receiverId: receiverModel!.uId!,
                              dateTime: DateTime.now().toString(),
                              message: messageController.text,
                            );
                            messageController.text = '';
                          },
                          icon: Icon(
                            Icons.send_rounded,
                            color: Colors.blue,
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget messageItem(MessageModel model)
  {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0 , vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
              bottomEnd: Radius.circular(10.0),
            ),
          ),
          child: Text(
            '${model.message}',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget myMessageItem(MessageModel model)
  {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0 , vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
              bottomStart: Radius.circular(10.0),
            ),
          ),
          child: Text(
            '${model.message}',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }



}

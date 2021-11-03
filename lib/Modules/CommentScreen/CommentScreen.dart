import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Model/CommentModel.dart';
import 'package:social_app/Shared/Cubits/MainCubit/cubit.dart';
import 'package:social_app/Shared/Cubits/MainCubit/states.dart';

class CommentScreen extends StatelessWidget {
  var commentController = TextEditingController();
  final int postIndex;

  CommentScreen( this.postIndex) ;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit , SocialStates>(
      listener: (context , state) {},
      builder: (context , state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Comments',
            ),
            leading: IconButton(
              onPressed: (){
                SocialCubit.get(context).commentBack();
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context , index) => commentItem(SocialCubit.get(context).comments[index]),
                    separatorBuilder: (context , index) => SizedBox(
                      height: 20.0,
                    ),
                    itemCount: SocialCubit.get(context).comments.length,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18.0,
                        backgroundImage: NetworkImage(
                            '${SocialCubit.get(context).userModel!.image}'
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          height: 36.0,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 18.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey[200],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Write a comment...',
                              border: InputBorder.none,
                            ),
                            controller: commentController,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                          SocialCubit.get(context).commentPost(SocialCubit.get(context).postId[postIndex], commentController.text);
                          commentController.text = '';
                        },
                        icon: Icon(
                          Icons.send_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget commentItem (CommentModel model)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(
                    '${model.image}'
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(
                    top: 5.0,
                    bottom: 10.0,
                    left: 15.0,
                    right: 15.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model.name}',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w900,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        '${model.comment}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


}

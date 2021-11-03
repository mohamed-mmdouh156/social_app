import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Model/PostModel.dart';
import 'package:social_app/Modules/CommentScreen/CommentScreen.dart';
import 'package:social_app/Modules/NewPost/NewPost.dart';
import 'package:social_app/Modules/SettingScreen/SettingScreen.dart';
import 'package:social_app/Shared/Componant/compontents.dart';
import 'package:social_app/Shared/Cubits/MainCubit/cubit.dart';
import 'package:social_app/Shared/Cubits/MainCubit/states.dart';

class FeedsScreen extends StatelessWidget {

  var commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return BlocConsumer<SocialCubit , SocialStates>(
          listener: (context , state){},
          builder: (context , state){
            return ConditionalBuilder(
              condition: SocialCubit.get(context).posts.length > 0,
              builder: (context) =>SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0 , bottom: 20.0 , right: 16.0 , left: 16.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: (){
                              navigateTo(context: context, widget: SettingScreen());
                            },
                            child: CircleAvatar(
                              radius: 24.0,
                              backgroundImage: NetworkImage(
                                  '${SocialCubit.get(context).userModel!.image!}'
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                navigateTo(context: context, widget: NewPost());
                              },
                              child: Container(
                                height: 45.0,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.grey[200],
                                ),
                                child: Text(
                                  'What\'s in your mind.?',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context , index) => postItem(SocialCubit.get(context).posts[index] ,context , index),
                      separatorBuilder: (context , index) => SizedBox(height: 5.0,),
                      itemCount: SocialCubit.get(context).posts.length,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                  ],
                ),
              ),
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        );
      },
    );
  }
  Widget postItem (PostModel model , context , index){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 2.0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28.0,
                    backgroundImage: NetworkImage(
                        '${SocialCubit.get(context).userModel!.image}'),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model.name}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w900,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          '${model.dateTime}',
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(
                            height: 1.3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                '${model.postText}',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 10.0),
              //   child: Wrap(
              //     children: [
              //       Text(
              //         '#Software',
              //         style: TextStyle(
              //           fontSize: 14.0,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.blue,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              if(model.postImage != '')
                Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Container(
                  width: double.infinity,
                  child: Image(
                    image: NetworkImage(
                        '${model.postImage}'
                    ),
                    fit: BoxFit.cover,
                    height: 200.0,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 14.0,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${SocialCubit.get(context).likes[index]}',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${SocialCubit.get(context).commentsNum[index]}',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Comments',
                          style: TextStyle(
                              fontSize: 12.0
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 20.0,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Like',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        SocialCubit.get(context).likePost(SocialCubit.get(context).postId[index]);
                      },
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mode_comment_outlined,
                            size: 20.0,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Comment',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        navigateTo(context: context, widget: CommentScreen(index));
                        SocialCubit.get(context).getComments(SocialCubit.get(context).postId[index]);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 1.0,
                color: Colors.grey[300],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 18.0,
                    backgroundImage: NetworkImage(
                        '${SocialCubit.get(context).userModel!.image!}'
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
                      SocialCubit.get(context).commentPost(SocialCubit.get(context).postId[index], commentController.text);
                      commentController.text = '';
                    },
                    icon: Icon(
                      Icons.send_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

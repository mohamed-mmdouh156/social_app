import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Modules/FeedsScreen/FeedsScreen.dart';
import 'package:social_app/Shared/Componant/compontents.dart';
import 'package:social_app/Shared/Cubits/MainCubit/cubit.dart';
import 'package:social_app/Shared/Cubits/MainCubit/states.dart';

class NewPost extends StatelessWidget {

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit , SocialStates>(
      listener: (context , state){},
      builder: (context , state){
        return Scaffold(
          appBar: AppBar(
            title: Text(
                'Create Post'
            ),
            actions: [
              TextButton(
                onPressed: (){
                  var dateNow = DateTime.now();
                  if(SocialCubit.get(context).postImage == null)
                    {
                      SocialCubit.get(context).createPost(
                          dateTime: dateNow.toString(),
                          text: textController.text,
                      );
                    }
                  else{
                    SocialCubit.get(context).uploadPostImage(
                        dateTime: dateNow.toString(),
                        text: textController.text,
                    );
                  }

                },
                child: Text(
                  'Post',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if(state is SocialLoadingCreatePostState)
                  LinearProgressIndicator(),
                if(state is SocialSuccessCreatePostState)
                  SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28.0,
                      backgroundImage: NetworkImage('${SocialCubit.get(context).userModel!.image}'),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mohamed Mmdouh',
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
                            'Public',
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
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'What is on your mind....',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                if(SocialCubit.get(context).postImage != null)
                  Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image(
                          image: FileImage(SocialCubit.get(context).postImage!),
                          fit: BoxFit.scaleDown,
                          height: 200.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: CircleAvatar(
                        radius: 20.0,
                        child: IconButton(
                          onPressed: () {
                            SocialCubit.get(context)
                                .removePostImage();
                          },
                          icon: Icon(
                            Icons.close,
                            size: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: (){
                          SocialCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_library_outlined,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'Add Photo',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: (){},
                        child: Text(
                          '# Tags',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

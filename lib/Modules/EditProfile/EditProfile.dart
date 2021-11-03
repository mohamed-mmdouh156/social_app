import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Modules/SettingScreen/SettingScreen.dart';
import 'package:social_app/Shared/Componant/compontents.dart';
import 'package:social_app/Shared/Cubits/MainCubit/cubit.dart';
import 'package:social_app/Shared/Cubits/MainCubit/states.dart';

class EditProfile extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  var profileImage;

  late ImageProvider profile;
  var coverImage;

  late ImageProvider cover;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
        ),
        actions: [
          TextButton(
            onPressed: () {
              SocialCubit.get(context).updateUserData(
                name: nameController.text,
                phone: phoneController.text,
                bio: bioController.text,
              );
            },
            child: Text(
              'UPDATE',
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
      body: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {
          if (state is SocialSuccessProfileImageState) {
            profileImage = SocialCubit.get(context).profileImage!;
            profile = FileImage(profileImage);
          }
          if (state is SocialSuccessCoverImageState) {
            coverImage = SocialCubit.get(context).coverImage!;
            cover = FileImage(coverImage);
          }
        },
        builder: (context, state) {
          var userModel = SocialCubit.get(context).userModel!;

          nameController.text = userModel.name!;
          bioController.text = userModel.bio!;
          phoneController.text = userModel.phone!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (state is SocialLoadingUploadUserState)
                      LinearProgressIndicator(),
                    if (state is SocialLoadingUploadUserState)
                      SizedBox(
                        height: 10.0,
                      ),
                    Container(
                      height: 200.0,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Image(
                                      image: coverImage == null
                                          ? NetworkImage('${userModel.cover!}')
                                          : cover,
                                      fit: BoxFit.cover,
                                      height: 150.0,
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
                                            .getCoverImage();
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        size: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 63.0,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage: profileImage == null
                                      ? NetworkImage('${userModel.image!}')
                                      : profile,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CircleAvatar(
                                  radius: 16.0,
                                  child: IconButton(
                                    onPressed: () {
                                      SocialCubit.get(context)
                                          .getProfileImage();
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    if (SocialCubit.get(context).profileImage != null ||
                        SocialCubit.get(context).coverImage != null)
                      Row(
                        children: [
                          if (SocialCubit.get(context).profileImage != null)
                            Expanded(
                              child: OutlineButton(
                                onPressed: () {
                                  SocialCubit.get(context).uploadProfileImage(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    bio: bioController.text,
                                  );
                                },
                                child: Text('Upload Profile'),
                              ),
                            ),
                          SizedBox(
                            width: 10.0,
                          ),
                          if (SocialCubit.get(context).coverImage != null)
                            Expanded(
                              child: OutlineButton(
                                onPressed: () {
                                  SocialCubit.get(context).uploadCoverImage(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    bio: bioController.text,
                                  );
                                },
                                child: Text('Upload Cover'),
                              ),
                            ),
                        ],
                      ),
                    if (SocialCubit.get(context).profileImage != null ||
                        SocialCubit.get(context).coverImage != null)
                      SizedBox(
                        height: 20.0,
                      ),
                    defaultFormField(
                      lable: 'Name',
                      textController: nameController,
                      prefixIcon: Icons.person,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Name must not be Empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    defaultFormField(
                      lable: 'Bio',
                      textController: bioController,
                      prefixIcon: Icons.info_outline,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'bio must not be Empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    defaultFormField(
                      lable: 'Bio',
                      textController: phoneController,
                      prefixIcon: Icons.phone,
                      textType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'bio must not be Empty';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

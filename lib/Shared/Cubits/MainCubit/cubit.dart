import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/Model/CommentModel.dart';
import 'package:social_app/Model/MessageModel.dart';
import 'package:social_app/Model/PostModel.dart';
import 'package:social_app/Model/UserModel.dart';
import 'package:social_app/Modules/ChatScreen/ChatScreen.dart';
import 'package:social_app/Modules/FeedsScreen/FeedsScreen.dart';
import 'package:social_app/Modules/NewPost/NewPost.dart';
import 'package:social_app/Modules/SettingScreen/SettingScreen.dart';
import 'package:social_app/Modules/UsersScreen/UsersScreen.dart';
import 'package:social_app/Shared/Componant/constants.dart';
import 'package:social_app/Shared/Cubits/MainCubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      //print(value.data());
      userModel = UserModel.fromFire(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print('error when get userData : ${error.toString()}');
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  UserModel? selectedUserModel;

  void getSelectedUserData({
  required String SelectedUserId,
  })
  {
    emit(SocialGetSelectedUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(SelectedUserId).get().then((value) {
      //print(value.data());
      selectedUserModel = UserModel.fromFire(value.data()!);
      emit(SocialGetSelectedUserSuccessState());
    }).catchError((error) {
      print('error when get selected User Model : ${error.toString()}');
      emit(SocialGetSelectedUserErrorState(error.toString()));
    });
  }



  List<Widget> screens = [
    FeedsScreen(),
    UsersScreen(),
    NewPost(),
    ChatScreen(),
    SettingScreen(),
  ];
  List<String> titles = ['Home', 'Users', 'New post', 'Chats', 'Settings'];

  int currentIndex = 0;

  void changeIndex(int index) {
    if(index == 3 || index == 1)
      getAllUsers();
    if (index == 2)
      emit(SocialNewPostState());
    else {
      currentIndex = index;
      emit(SocialChangeNavBarState());
    }
  }

  File? profileImage;

  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialSuccessProfileImageState());
    } else {
      print('No Image selected.');
      emit(SocialErrorProfileImageState());
    }
  }

  File? coverImage;

  var coverPicker = ImagePicker();

  Future<void> getCoverImage() async {
    final pickedFile = await coverPicker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialSuccessCoverImageState());
    } else {
      print('No Image selected.');
      emit(SocialErrorCoverImageState());
    }
  }

  String profileUrlImage = '';

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialLoadingUploadUserState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialSuccessUploadProfileImageState());
        profileUrlImage = value;
        print(value);
        updateUserData(name: name, phone: phone, bio: bio, image: value);
      }).catchError((error) {
        emit(SocialErrorUploadProfileImageState());
      });
    }).catchError((error) {
      emit(SocialErrorUploadProfileImageState());
    });
  }

  String coverUrlImage = '';

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialLoadingUploadUserState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialSuccessUploadCoverImageState());
        coverUrlImage = value;
        print(value);
        updateUserData(name: name, phone: phone, bio: bio, cover: value);
      }).catchError((error) {
        emit(SocialErrorUploadCoverImageState());
      });
    }).catchError((error) {
      emit(SocialErrorUploadCoverImageState());
    });
  }

  // void updateUserImages({
  //   required String name,
  //   required String phone,
  //   required String bio,
  // }) {
  //   emit(SocialLoadingUploadUserState());
  //   if (coverImage != null) {
  //     uploadCoverImage();
  //   } else if (profileImage != null) {
  //     uploadProfileImage();
  //   } else if (profileImage != null && coverImage != null) {
  //   } else {
  //     updateUserData(
  //       name: name,
  //       phone: phone,
  //       bio: bio,
  //     );
  //   }
  // }

  void updateUserData({
    required String name,
    required String phone,
    required String bio,
    String? image,
    String? cover,
  }) {
    emit(SocialLoadingUploadUserState());
    UserModel model = UserModel(
      name: name,
      phone: phone,
      image: image ?? userModel!.image!,
      cover: cover ?? userModel!.cover!,
      email: userModel!.email,
      uId: userModel!.uId,
      bio: bio,
      isVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId!)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialErrorUploadUserState());
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialSuccessPostImageState());
    } else {
      print('No Image selected.');
      emit(SocialErrorPostImageState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialLoadingCreatePostState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          dateTime: dateTime,
          text: text,
          postImage: value,
        );
        emit(SocialSuccessCreatePostState());
        print(value);
      }).catchError((error) {
        emit(SocialErrorCreatePostState());
      });
    }).catchError((error) {
      emit(SocialErrorCreatePostState());
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(SocialLoadingUploadUserState());
    PostModel model = PostModel(
      name: userModel!.name!,
      image: userModel!.image!,
      uId: userModel!.uId,
      dateTime: dateTime,
      postText: text,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
          value.snapshots().listen((event) {
            posts = [] ;
            getPosts();
          });
          emit(SocialSuccessCreatePostState());
    }).catchError((error) {
      emit(SocialErrorCreatePostState());
    });
  }

  List<PostModel> posts = [];
  List<String> postId = [];
  List<int> likes = [];
  List<int> commentsNum = [];
  List<CommentModel> comments = [];

  void getPosts() {
    FirebaseFirestore.instance.collection('posts').orderBy('dateTime').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('comments').get().then((value) {
          commentsNum.add(value.docs.length);
          postId.add(element.id);
          posts.add(PostModel.fromFire(element.data()));
        }).catchError((error){});
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
        }).catchError((error){});
      });
      emit(SocialGetPostsSuccessState());
    }).catchError((error){
      print('error when get posts ${error.toString()}');
      emit(SocialGetPostsErrorState(error.toString()));
    });

  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(SocialLikePostsSuccessState());
    }).catchError((error) {
      print('Error When set likes : ${error.toString()}');
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  void commentPost(String postId, String comment) {
    CommentModel model = CommentModel(
      name: userModel!.name!,
      image: userModel!.image!,
      uId: userModel!.uId,
      comment: comment,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(model.toMap())
        .then((value) {
          value.snapshots().listen((event) {
            comments = [] ;
            getComments(postId);
          });
      emit(SocialCommentPostsSuccessState());
    }).catchError((error) {
      print('Error When set likes : ${error.toString()}');
      emit(SocialCommentPostErrorState(error.toString()));
    });
  }

  void getComments(String postId) {
    comments = [];
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((value) {
          value.reference.collection('comments').get().then((value) {
          value.docs.forEach((element) {
            comments.add(CommentModel.fromFire(element.data()));
          });
          emit(SocialGetCommentSuccessState());
        }).catchError((error) {
          print('Error When get Comments');
        });
    }).catchError((error) {
      emit(SocialGetCommentErrorState(error.toString()));
    });
  }

  void commentBack(){
    comments = [] ;
    emit(SocialCommentBackSuccessState());
  }

  List<UserModel> users = [];

  void getAllUsers()
  {
    if (users.length == 0)
      FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) {
          value.docs.forEach((element) {
            users.add(UserModel.fromFire(element.data()));
        });
      emit(SocialGetAllUserSuccessState());
      }).catchError((error) {
      print('Error when get All users : ${error.toString()}');
      emit(SocialGetAllUserErrorState(error.toString()));
      });
  }

  void sendMessage({
    required String receiverId ,
    required String dateTime ,
    required String message ,
  })
  {
    MessageModel model = MessageModel(
      receiverId: receiverId,
      senderId: userModel!.uId,
      message: message,
      dateTime: dateTime,
    );

    FirebaseFirestore.instance
    .collection('users')
    .doc(userModel!.uId)
    .collection('chats')
    .doc(receiverId)
    .collection('messages')
    .add(model.toMap())
    .then((value) {
      emit(SocialSuccessSendMessageState());
    })
    .catchError((error){
      emit(SocialErrorSendMessageState(error.toString()));
    });


    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSuccessSendMessageState());
    })
        .catchError((error){
      emit(SocialErrorSendMessageState(error.toString()));
    });


  }


  List<MessageModel> messages = [];


  void getMessages ({required String receiverId ,})
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
          messages = [];
          event.docs.forEach((element) {
            messages.add(MessageModel.fromFire(element.data()));

          });
          emit(SocialSuccessGetMessageState());
    });
  }


  List <PostModel> myPosts = [];

  void getMyPosts()
  {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.collection('comments').get().then((value) {
          commentsNum.add(value.docs.length);
          postId.add(element.id);
          if(PostModel.fromFire(element.data()).uId == userModel!.uId)
            myPosts.add(PostModel.fromFire(element.data()));
        }).catchError((error){});
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
        }).catchError((error){});
      });
      emit(SocialGetPostsSuccessState());
    }).catchError((error){
      print('error when get posts ${error.toString()}');
      emit(SocialGetPostsErrorState(error.toString()));
    });

  }


  List <PostModel> selectedUserPosts = [];
  void getSelectedUserPosts()
  {
    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.collection('comments').get().then((value) {
          commentsNum.add(value.docs.length);
          postId.add(element.id);
          if(PostModel.fromFire(element.data()).uId == selectedUserModel!.uId)
            selectedUserPosts.add(PostModel.fromFire(element.data()));
        }).catchError((error){});
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
        }).catchError((error){});
      });

      emit(SocialSuccessGetSelectedUserPostState());
    }).catchError((error){
      print('error when get posts ${error.toString()}');
      emit(SocialSuccessGetSelectedUserPostState());
    });

  }


}

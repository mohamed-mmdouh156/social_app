abstract class SocialStates {}

class SocialInitialState extends SocialStates{}

class SocialGetUserLoadingState extends SocialStates{}
class SocialGetUserSuccessState extends SocialStates{}
class SocialGetUserErrorState extends SocialStates{
  final String error ;

  SocialGetUserErrorState(this.error);
}

class SocialGetSelectedUserLoadingState extends SocialStates{}
class SocialGetSelectedUserSuccessState extends SocialStates{}
class SocialGetSelectedUserErrorState extends SocialStates{
  final String error ;

  SocialGetSelectedUserErrorState(this.error);
}

class SocialGetAllUserSuccessState extends SocialStates{}
class SocialGetAllUserErrorState extends SocialStates{
  final String error ;

  SocialGetAllUserErrorState(this.error);
}

class SocialGetPostsLoadingState extends SocialStates{}
class SocialGetPostsSuccessState extends SocialStates{}
class SocialGetPostsErrorState extends SocialStates{
  final String error ;

  SocialGetPostsErrorState(this.error);
}

class SocialLikePostsSuccessState extends SocialStates{}
class SocialLikePostErrorState extends SocialStates{
  final String error ;

  SocialLikePostErrorState(this.error);
}

class SocialCommentPostsSuccessState extends SocialStates{}
class SocialCommentPostErrorState extends SocialStates{
  final String error ;

  SocialCommentPostErrorState(this.error);
}

class SocialGetCommentSuccessState extends SocialStates{}
class SocialGetCommentErrorState extends SocialStates{
  final String error ;

  SocialGetCommentErrorState(this.error);
}

class SocialCommentBackSuccessState extends SocialStates{}


class SocialNewPostState extends SocialStates {}

class SocialSuccessProfileImageState extends SocialStates {}
class SocialErrorProfileImageState extends SocialStates {}

class SocialSuccessCoverImageState extends SocialStates {}
class SocialErrorCoverImageState extends SocialStates {}

class SocialChangeNavBarState extends SocialStates {}

class SocialSuccessUploadProfileImageState extends SocialStates {}
class SocialErrorUploadProfileImageState extends SocialStates {}

class SocialSuccessUploadCoverImageState extends SocialStates {}
class SocialErrorUploadCoverImageState extends SocialStates {}
class SocialLoadingUploadUserState extends SocialStates {}

class SocialErrorUploadUserState extends SocialStates {}


class SocialLoadingCreatePostState extends SocialStates {}
class SocialSuccessCreatePostState extends SocialStates {}
class SocialErrorCreatePostState extends SocialStates {}

class SocialSuccessPostImageState extends SocialStates {}
class SocialErrorPostImageState extends SocialStates {}


class SocialSuccessSendMessageState extends SocialStates {}
class SocialErrorSendMessageState extends SocialStates {
  final String error ;

  SocialErrorSendMessageState(this.error);
}

class SocialSuccessGetMessageState extends SocialStates {}

class SocialRemovePostImageState extends SocialStates {}

class SocialSuccessGetSelectedUserPostState extends SocialStates {}
class SocialErrorGetSelectedUserPostState extends SocialStates {}

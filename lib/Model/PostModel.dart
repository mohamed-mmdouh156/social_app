class PostModel{
  String? name;
  String? uId;
  String? image;
  String? dateTime;
  String? postText;
  String? postImage;


  PostModel({
    this.name,
    this.uId,
    this.image,
    this.dateTime,
    this.postImage,
    this.postText,
  });

  PostModel.fromFire(Map <String , dynamic> fire ){
    name = fire['name'];
    uId = fire['uId'];
    image = fire['image'];
    dateTime = fire['dateTime'];
    postImage = fire['postImage'];
    postText = fire['postText'];
  }


  Map <String , dynamic> toMap (){
    return {
      'name' : name ,
      'uId' : uId ,
      'image': image ,
      'dateTime': dateTime ,
      'postImage': postImage ,
      'postText': postText ,
    };
  }

}
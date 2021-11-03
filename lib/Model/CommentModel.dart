class CommentModel{
  String? name;
  String? uId;
  String? image;
  String? comment;


  CommentModel({
    this.name,
    this.uId,
    this.image,
    this.comment,

  });

  CommentModel.fromFire(Map <String , dynamic> fire ){
    name = fire['name'];
    uId = fire['uId'];
    image = fire['image'];
    comment = fire['comment'];

  }


  Map <String , dynamic> toMap (){
    return {
      'name' : name ,
      'uId' : uId ,
      'image': image ,
      'comment': comment ,
    };
  }

}
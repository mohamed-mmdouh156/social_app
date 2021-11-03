class UserModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? image;
  String? cover;
  String? bio;
  bool? isVerified;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.uId,
    this.image,
    this.cover,
    this.bio,
    this.isVerified,
  });

  UserModel.fromFire(Map <String , dynamic> fire ){
    name = fire['name'];
    email = fire['email'];
    phone = fire['phone'];
    uId = fire['uId'];
    image = fire['image'];
    cover = fire['cover'];
    bio = fire['bio'];
    isVerified = fire['isVerified'];
  }


  Map <String , dynamic> toMap (){
    return {
      'name' : name ,
      'email' : email ,
      'phone' : phone ,
      'uId' : uId ,
      'image': image ,
      'bio': bio,
      'cover' : cover,
      'isVerified' : isVerified ,
    };
  }


}
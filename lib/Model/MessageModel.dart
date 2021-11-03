class MessageModel{
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? message;


  MessageModel({
    this.senderId,
    this.receiverId,
    this.dateTime,
    this.message,

  });

  MessageModel.fromFire(Map <String , dynamic> fire ){
    senderId = fire['senderId'];
    receiverId = fire['receiverId'];
    dateTime = fire['dateTime'];
    message = fire['message'];

  }


  Map <String , dynamic> toMap (){
    return {
      'senderId' : senderId ,
      'receiverId' : receiverId ,
      'dateTime': dateTime ,
      'message': message ,
    };
  }

}
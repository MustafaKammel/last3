class Message
{
  String? id;
  String? toId;
  String? fromId;
  String? msg;
  String? type;
  String? createdAt;
  String? read;


  Message({
    required this.id,
    required this.toId,
    required this.fromId,
    required this.msg,
    required this.type,
    required this.createdAt,
    required this.read,
  });

  factory Message.fromjson(Map<String,dynamic> json){
    return Message(
      id: json['id'] ?? '',
      toId: json['to_id'],
      fromId: json['from_id'],
      msg: json['msg'],
      type: json['type'],
      createdAt: json['created_at'],
      read: json['read'],
    );

  }

  Map<String,dynamic> tojson(){
    return {
      'id':id,
      'to_id':toId,
      'from_id':fromId,
      'msg':msg,
      'type':type,
      'created_at':createdAt,
      'read':read,
    };
  }

}
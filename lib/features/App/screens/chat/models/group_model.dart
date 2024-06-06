class ChatGroup
{
  String id;
  String name;
  String image;
  List members;
  List admin;
  String lastMessage;
  String lastMessageTime;
  String createdAt;


  ChatGroup({
    required this.id,
    required this.createdAt,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.members,
    required this.name,
    required this.image,
    required this.admin,
  });

  factory ChatGroup.fromjson(Map<String,dynamic> json){
    return ChatGroup(
      id: json['id'] ?? '',
      lastMessage: json['last_message'] ?? "",
      lastMessageTime: json['last_message_time'] ?? "",
      members: json['members'] ?? [],
      admin: json['admins_id'] ?? [],
      createdAt: json['created_at'],
      image: json['image'] ?? "",
      name: json['name'] ?? "",
    );

  }

  Map<String,dynamic> tojson(){
    return {
      'id':id,
      'created_at':createdAt,
      'members':members,
      'last_message_time':lastMessageTime,
      'last_message':lastMessage,
      'admins_id' : admin,
      'image' : image,
      'name' : name,
    };
  }

}
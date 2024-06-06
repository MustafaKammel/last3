class ChatRoom
{
  String? id;
  List? members;
  String? lastMessage;
  String? lastMessageTime;
  String? createdAt;


  ChatRoom({
    required this.id,
    required this.createdAt,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.members,

  });

  factory ChatRoom.fromjson(Map<String,dynamic> json){
    return ChatRoom(
      id: json['id'] ?? '',
      lastMessage: json['last_message'] ?? "",
      lastMessageTime: json['last_message_time'] ?? "",
      members: json['members'] ?? [],
      createdAt: json['created_at'],
    );

  }

  Map<String,dynamic> tojson(){
    return {
      'id':id,
      'created_at':createdAt,
      'members':members,
      'last_message_time':lastMessageTime,
      'last_message':lastMessage,
    };
  }

}
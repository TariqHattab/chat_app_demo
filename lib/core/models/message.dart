class MessageModel {
  late String messageText;
  late String id;
  String? sentBy;
  var sentAt;
  MessageModel({
    required this.id,
    required this.messageText,
    this.sentBy,
    this.sentAt,
  });
  MessageModel.fromMap(Map<String, dynamic> message, this.id) {
    sentBy = message['sentBy'];
    sentAt = message['sentAt'];
    messageText = message['messageText'];
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['sentBy'] = sentBy;
    data['sentAt'] = sentAt;
    data['messageText'] = messageText;
    return data;
  }
}

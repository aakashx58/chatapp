///to create chat room

String createChatRoom(String user1Uid, String user2Uid) {
  List<String> uidList = [user1Uid, user2Uid];
  uidList.sort();
  return uidList.toString();
}

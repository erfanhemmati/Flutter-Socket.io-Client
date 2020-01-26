class ChatModel {
  final int id;
  final String name;
  final String message;
  final String time;
  final String avatarUrl;

  ChatModel({this.id, this.name, this.message, this.time, this.avatarUrl});
}

List<ChatModel> dummyData = [
  new ChatModel(
      name: "عرفان همتی",
      message: "سلام، من عرفان همتی هستم",
      time: "03:30",
      avatarUrl:
          "http://www.usanetwork.com/sites/usanetwork/files/styles/629x720/public/suits_cast_harvey.jpg?itok=fpTOeeBb")
];

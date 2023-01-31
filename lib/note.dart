class Note {
  final int id;
  final String title;
  final String content;
  final DateTime createTime;
  final DateTime updateTime;

  static Note newNote(String title) {
    return Note(
        id: 0,
        title: title,
        content: "",
        createTime: DateTime(1970),
        updateTime: DateTime(1970));
  }

  static Note newNoteFromMap(Map<String, dynamic> map) {
    return Note(
        id: map["id"],
        title: map["title"],
        content: map["content"],
        createTime: DateTime.fromMillisecondsSinceEpoch(map["create_time"]),
        updateTime: DateTime.fromMillisecondsSinceEpoch(map["update_time"]));
  }

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createTime,
    required this.updateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }
}

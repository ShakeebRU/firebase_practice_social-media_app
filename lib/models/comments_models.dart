class CommentsModel {
  CommentsModel({
    required this.uid,
    required this.postId,
    required this.text,
  });
  late final String uid;
  late final String postId;
  late final String text;

  CommentsModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    postId = json['postId'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['uid'] = uid;
    _data['postId'] = postId;
    _data['text'] = text;
    return _data;
  }
}

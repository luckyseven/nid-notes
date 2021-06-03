class Note {
  int? id;
  String title;
  String? content;
  String? image;

  Note(this.title, this.content, {this.id, this.image});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image': image,
    };
  }

}
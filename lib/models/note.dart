class Note {
  int? id;
  String title;
  String? content;
  String? image;
  bool favorite;

  Note(this.title, this.content, {this.id, this.image, this.favorite=false} );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image': image,
      'favorite': favorite ? 1 : 0,
    };
  }

}
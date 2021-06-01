
final String table= 'notes';
class Fields{

  static final List<String>values= [id,title,content,favourite,number,created];

  static final String id= '_id';
  static final String title= 'title';
  static final String content= 'content';
  static final String favourite= 'favourite';
  static final String number= 'number';
  static final String created= 'created';
}

class Note{
  final int? id;
  final String title;
  final String content;
  final bool favourite;
  final int number;
  final DateTime created;

  const Note({
    this.id,
    required this.title,
    required this.content,
    required this.favourite,
    required this.number,
    required this.created
  });

  Note copy ({int? id, String? title,String? content, bool? favourite,int? number, DateTime? created}) =>
      Note(title: title?? this.title, content: content?? this.content, favourite: favourite?? this.favourite, number: number?? this.number, created: created?? this.created);

  Map<String, Object?> toJson()=>{
    Fields.id : id,
    Fields.title : title,
    Fields.content : content,
    Fields.favourite : favourite? 1 : 0,
    Fields.number : number,
    Fields.created : created.toIso8601String(),
  };

  static Note fromJson(Map<String, Object?> json)=> Note(
      id: json[Fields.id] as int?,
      title: json[Fields.title] as String,
      content: json[Fields.content] as String,
      favourite: json[Fields.favourite] == 1,
      number: json[Fields.number] as int,
      created: DateTime.parse(json[Fields.created] as String),);

}
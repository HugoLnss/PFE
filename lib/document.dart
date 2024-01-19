class Document {
  int id;
  String title;
  String fileType;
  String path;  // chemin du fichier
  DateTime creationDate;
  int ownerId; // id de l'utilisateur propriétaire du document
  

  Document({
    required this.id,
    required this.title,
    required this.fileType,
    required this.path,
    required this.creationDate,
    required this.ownerId,
  });

  
}

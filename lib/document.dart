import 'package:docare/folder.dart';
import 'file_system_entity.dart';

class Document extends FileSystemEntity {
  int id;
  String title;
  String fileType;
  String path;  // chemin du fichier
  DateTime creationDate;
  int ownerId; // id de l'utilisateur propriétaire du document
  Folder folder; // id du dossier dans lequel se trouve le document

  Document({
    required this.id,
    required this.title,
    required this.fileType,
    required this.path,
    required this.creationDate,
    required this.ownerId,
    required this.folder,
  
  }) : super(name: title, type: false) {
    folder.addFile(this); // Ajout du document au dossier
  }

  // Getters
  int getId() {return id;}
  String getTitle() {return title;}
  String getFileType() {return fileType;}
  String getPath() {return path;}
  DateTime getCreationDate() {return creationDate;}
  int getOwnerId() {return ownerId;}
  Folder getFolderId() {return folder;}
}

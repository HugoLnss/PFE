import 'document.dart';
import 'user.dart';

class Folder {

  int id;
  String name;
  int parentId;
  List<Folder> folders;
  List<Document> files;
  User ownerId;           // full access
  List <User> sharedWith; // read only (?)
  

  // Constructor
  Folder({
    required this.id,
    required this.name,
    required this.parentId,
    required this.folders,
    required this.files,
    required this.ownerId,
    required this.sharedWith,
  });

  // Add a folder to the list of folders
  void addFolder(Folder folder) {
    folders.add(folder);
  }
  // Remove a folder from the list of folders
  void removeFolder(Folder folder) {
    folders.remove(folder);
  }
  
  // Add a file to the list of files
  void addFile(Document file) {
    files.add(file);
  }
  // Remove a file from the list of files
  void removeFile(Document file) {
    files.remove(file);
  }

  // Add a user to the list of users with read only access
  void addUser(User user) {
    sharedWith.add(user);
  }
  // Remove a user from the list of users with read only access
  void removeUser(User user) {
    sharedWith.remove(user);
  }

  // Getters
  int getId() {return id;}
  String getName() {return name;}
  int getParentId() {return parentId;}
  List<Folder> getFolders() {return folders;}
  List<Document> getFiles() {return files;}
  User getOwnerId() {return ownerId;}
  List <User> getSharedWith() {return sharedWith;}


}
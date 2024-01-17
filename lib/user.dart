import 'package:docare/document.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'
    show ChangeNotifier, ChangeNotifierProvider;

class User extends ChangeNotifier {
  int userId;
  String username;
  String email;
  String passwordHash;
  List<Document> documentList; // liste des documents de l'utilisateur

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.documentList,
  });

  // ajoute un document à la liste des documents de l'utilisateur
  void addDocument(Document document) {
    documentList.add(document);
    notifyListeners(); // If User extends ChangeNotifier
  }
}

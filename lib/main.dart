import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:docare/user.dart';
import 'package:docare/document.dart';
import 'package:docare/doc_mobile.dart' // par defaut charge la version mobile
    if (dart.library.html) 'package:docare/doc_web.dart'; // sinon charge la version web

import 'package:provider/provider.dart'; // Pour utiliser le provider
import 'package:docare/user.dart'; // Pour utiliser la classe User
import 'package:docare/document.dart'; // Pour utiliser la classe Document

void main() {
  // Create user
  User currentUser = User(
    userId: 1,
    username: 'Lucas',
    email: 'lucas@example.com',
    passwordHash: 'password',
    documentList: [],
  );

  Document CNI = Document(
    id: 1,
    title: "Carte d'identité",
    fileType: 'img',
    path: 'assets/documents/CNI_example.png',
    creationDate: DateTime.now(),
    ownerId: currentUser.userId, // id de l'utilisateur propriétaire du document
  );
  Document annaleIAM = Document(
    id: 1,
    title: "annale d'IAM",
    fileType: 'pdf',
    path: 'assets/documents/iam_DS-3.pdf',
    creationDate: DateTime.now(),
    ownerId: currentUser.userId, // id de l'utilisateur propriétaire du document
  );
  currentUser.addDocument(CNI);
  currentUser.addDocument(annaleIAM);

  runApp(
    ChangeNotifierProvider<User>(
      create: (context) => currentUser, // On fournit l'utilisateur
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key}); // Constructeur
  
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOCare',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'DOCare Home Page'),
    );
    
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color.fromARGB(255, 53, 0, 243), Colors.white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/docare_logo.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const Text('Bienvenue sur DOCare !',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const Text('Votre application tri administratif intelligent',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            const Spacer(flex: 4),

            // Bouton pour la page 1 //
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DocumentInterface()),
                  );
                },
                // style pour le bouton "Mes documents"
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Couleur de fond du bouton
                  foregroundColor: Color.fromARGB(
                      255, 53, 0, 243), // Couleur du texte du bouton
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 17),
                ),
                child:
                    const Text('Mes documents', style: TextStyle(fontSize: 20)),
              ),
            ),

            // Espacement entre les boutons //
            const SizedBox(height: 20),

            // Bouton pour la page 2 //
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Ajouter la page 2
                },
                // style pour le bouton "Mes démarches"
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Couleur de fond du bouton
                  foregroundColor: const Color.fromARGB(
                      255, 53, 0, 243), // Couleur du texte du bouton
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 17),
                ),
                child:
                    const Text('Mes démarches', style: TextStyle(fontSize: 20)),
              ),
            ),

            const Spacer(flex: 2)
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:docare/main.dart';
import 'package:file_picker/file_picker.dart'; // Pour sélectionner un fichier
import 'dart:typed_data'; // Pour convertir un fichier en bytes
import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart'; // Pour utiliser le provider
import 'package:docare/user.dart'; // Pour utiliser la classe User
import 'package:docare/document.dart'; // Pour utiliser la classe Document

// imports pour open_filex (pour ouvrir les fichiers)
import 'package:open_filex/open_filex.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DocumentInterface extends StatefulWidget {
  @override
  _DocumentInterfaceState createState() => _DocumentInterfaceState();
}

class _DocumentInterfaceState extends State<DocumentInterface> {
  // This method uses open_filex to open the file.
  void _openFile(Document file, BuildContext context) async {
    if (file.fileType == 'pdf') {
      // Si le document est un PDF
      final byteData = await rootBundle.load(file.path);
      final tempDir = await getTemporaryDirectory();
      final fileName = file.path.split('/').last;
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(
          byteData.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
          flush: true);

      final result = await OpenFilex.open(tempFile.path);

      // If the PDF couldn't be opened, show an error.
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to open the file: ${result.message}"),
          ),
        );
      }
    } else if (file.fileType == 'img') {
      // Si le document est une image
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content:
              Image.asset(file.path), // Assuming `path` is a valid asset path
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  // Méthode pour construire la barre de recherche
  Widget buildTopBar(BuildContext context) {
    // Utilisez MediaQuery pour obtenir la largeur de l'écran
    double screenWidth = MediaQuery.of(context).size.width;

    // Déterminez la taille des boutons en fonction de la largeur de l'écran
    double buttonWidth = screenWidth > 600 ? 200 : screenWidth / 4;
    double padding = screenWidth > 600 ? 50.0 : 8.0;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(padding),
      color: Colors.blue,
      child: Row(
        children: <Widget>[
          const SizedBox(width: 8.0), // Espace entre les boutons
          // Expanded fait que la barre de recherche prend le reste de l'espace disponible
          Expanded(
            flex:
                2, // Donne plus de flexibilité à la barre de recherche par rapport aux boutons
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Rechercher un document',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => searchDocuments(value), // Recherche
            ),
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttonWidth),
              child: ElevatedButton(
                onPressed: () async {
                  // async pour pouvoir utiliser await
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    withData: true, // Récupérer les données du fichier
                    type: FileType.custom,
                    allowedExtensions: [
                      'jpg',
                      'jpeg',
                      'png',
                      'pdf'
                    ], // Extensions de fichier autorisées
                  );

                  if (result != null) {
                    PlatformFile file = result.files.first;

                    // Vérifiez si le fichier est une image
                    if (['jpg', 'jpeg', 'png'].contains(file.extension)) {
                      // Convertir en Uint8List
                      Uint8List? fileBytes = file.bytes;
                      if (fileBytes != null) {
                        // Proceed with your logic
                        Widget image = Image.memory(fileBytes);

                        // Ajouter le document à la liste des documents de l'utilisateur
                        // TO DO:
                      } else {
                        // Handle the situation where bytes are not available
                        print('Error: File bytes are null');
                      }
                    } else if (file.extension == 'pdf') {
                      // Faire de même pour les PDF
                    } else {
                      // Gérer les autres types de fichiers ici
                      print(
                          'Type de fichier non supporté pour la visualisation directe.');
                    }
                  } else {
                    // L'utilisateur a annulé la sélection de fichier
                    print('Aucun fichier sélectionné.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  // Style du bouton
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  textStyle: TextStyle(
                    fontSize: screenWidth > 600
                        ? 20
                        : 14, // Ajuster cette valeur si nécessaire
                  ),
                ),

                child: screenWidth > 700 // S'adapter à la taille de l'écran
                    ? Text(
                        'Ajouter un document') // Si l'écran est large (texte)
                    : Icon(Icons.add,
                        color: Colors.blue), // Si l'écran est petit (icone)
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttonWidth),
              child: ElevatedButton(
                onPressed: () async {
                  // TO DO: Prendre une photo
                },
                style: ElevatedButton.styleFrom(
                  // Style du bouton
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  textStyle: TextStyle(
                    fontSize: screenWidth > 600
                        ? 20
                        : 14, // Ajuster cette valeur si nécessaire
                  ),
                ),

                child: screenWidth > 700 // S'adapter à la taille de l'écran
                    ? Text('Prendre une photo') // Si l'écran est large (texte)
                    : Icon(Icons.camera_alt,
                        color: Colors.blue), // Si l'écran est petit (icone)
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController searchController =
      TextEditingController(); // Contrôleur pour la barre de recherche
  List<Document> filteredDocuments = []; // Liste des documents filtrés

  @override
  void initState() {
    // Méthode appelée au démarrage de l'application
    super.initState();
    // Assuming `Provider.of<User>(context, listen: false).documentList` is your initial full list
    filteredDocuments = Provider.of<User>(context, listen: false).folderList.first.files; // liste des documents de l'utilisateur (dossier racine)
  }

  // Méthode pour rechercher un document
  void searchDocuments(String query) {
    final documents = Provider.of<User>(context, listen: false).folderList.first.files; // liste des documents de l'utilisateur (dossier racine)
    if (query.isEmpty) {
      setState(() {
        filteredDocuments = documents;
      });
    } else {
      setState(() {
        filteredDocuments = documents
            .where(
                (doc) => doc.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //final userProvider = Provider.of<User>(context, listen: false);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
        children: <Widget>[
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.only(bottom: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  // InkWell pour rendre l'image cliquable
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MyApp()), // Retour à la page d'accueil
                    );
                  },
                  child: Image.asset(
                    'assets/images/docare_logo.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Bienvenue dans votre assistant de gestion de document',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          buildTopBar(
              context), // Barre de recherche (voir la méthode buildTopBar)
          // texte "Mes documents" aligné à gauche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: filteredDocuments.isEmpty // Si aucun document n'est trouvé dans la recherche ou si aucun document n'a été ajouté
                ? Text(
                    "Aucun document trouvé",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  )
                : Text(
                    "Récemment ajoutés",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
          ),
          Flexible(
            child: GridView.builder(
              padding: const EdgeInsets.all(4.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (MediaQuery.of(context).size.width / 200)
                    .floor(), // le nobre d'éléments par ligne (adapté selon la taille de l'écran)
                crossAxisSpacing: 10.0, // Espace horizontal entre les éléments
                mainAxisSpacing: 10.0, // Espace vertical entre les éléments
              ),
              itemCount: filteredDocuments
                  .length, // Remplacer par le nombre réel de documents
              itemBuilder: (context, index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () { // Lorsque l'utilisateur clique sur un document
                      // Vérifiez si le fichier est une image
                      Document file = filteredDocuments[index];
                      _openFile(file, context);
                    },
                    child: GridTile(
                      footer: Container(
                        padding: const EdgeInsets.all(4.0),
                        color: Colors.blue.withOpacity(0.8),
                        child: Text(
                          filteredDocuments[index].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      child: filteredDocuments[index].fileType ==
                              'img' // Si le document est une image
                          ? // Conditionally render the Image.asset widget
                          Image.asset(
                              filteredDocuments[index].path,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons
                                  .picture_as_pdf, // Sinon, afficher l'icone PDF
                              size: 50,
                              color: Colors
                                  .blue), // Render the Icon widget if it's not an image
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

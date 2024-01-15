import 'package:flutter/material.dart';
import 'package:docare/main.dart';
import 'package:file_picker/file_picker.dart'; // Pour sélectionner un fichier
import 'dart:typed_data'; // Pour convertir un fichier en bytes
import 'dart:html' as html; // Pour afficher une image dans un dialogue
import 'package:flutter/services.dart' show rootBundle; // Pour charger un fichier depuis les assets

import 'package:flutter/foundation.dart'; 
import 'dart:ui_web' as ui; // Pour afficher un pdf dans un dialogue

class Document extends StatelessWidget {
  
  // Méthode pour charger un pdf depuis les assets
  Future<Uint8List> loadPdfFromAssets(String path) async {
    final byteData = await rootBundle.load(path);
    return byteData.buffer.asUint8List();
} 


  // Méthode pour afficher un pdf dans un dialogue
  Future<void> _displayPdf(BuildContext context, Uint8List fileBytes) async {

    // Create a Blob from the Uint8List
    final blob = html.Blob([fileBytes], 'application/pdf');
    // Create an object URL for the Blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Define a unique ID for the view
    final uniqueId = 'pdf-viewer-${DateTime.now().millisecondsSinceEpoch}';

    // Register the view factory if not already registered
    // Note: The new API does not require checking if it's registered
    ui.platformViewRegistry.registerViewFactory(
      uniqueId,
      (int viewId) => html.IFrameElement()
        ..src = url
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
    );

    // Display the PDF in an AlertDialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 800, // Set the height of the dialog
            width: 1200,
            child: HtmlElementView(viewType: uniqueId),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
                html.Url.revokeObjectUrl(url);
              },
            ),
          ],
        );
      },
    );
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
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttonWidth),
              child: ElevatedButton( // Bouton pour ajouter un document
                onPressed: () async {
                  // async pour pouvoir utiliser await
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    // Sélectionner un fichier
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'], // Extensions de fichier autorisées
                  );

                  if (result != null) {
                    PlatformFile file = result.files.first;

                    // Vérifiez si le fichier est une image
                    if (['jpg', 'jpeg', 'png'].contains(file.extension)) {
                      // Convertir en Uint8List
                      Uint8List fileBytes = file.bytes!;
                      // Créer une image à partir des bytes
                      Widget image = Image.memory(fileBytes);

                      // Afficher l'image dans un dialogue
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: image,
                          actions: <Widget>[
                            TextButton(
                              child: Text('Fermer'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    } else if (file.extension == 'pdf') {
                      PlatformFile file = result.files.first; // Récupérer le fichier
                      Uint8List? fileBytes = file.bytes; // Convertir en Uint8List
                      if (fileBytes != null) {
                        await _displayPdf(context, fileBytes); // Appelle la methode pour afficher le pdf
                      }

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
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  textStyle: TextStyle(
                    fontSize: screenWidth > 600
                        ? 20
                        : 14, // Ajuster cette valeur si nécessaire
                  ),
                ),
                child: screenWidth > 700
                    ? Text('Ajouter un document') // Si l'écran est large (texte)
                    : Icon(Icons.add, color: Colors.blue) // Si l'écran est petit (icone)
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          // Expanded fait que la barre de recherche prend le reste de l'espace disponible
          const Expanded(
            flex:
                2, // Donne plus de flexibilité à la barre de recherche par rapport aux boutons
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Rechercher un document',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          // Utilisez Flexible pour que le bouton "Rechercher" s'adapte à la taille de l'écran
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttonWidth),
              child: ElevatedButton(
                onPressed: () {
                  // Code pour ajouter un document
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  textStyle: TextStyle(
                    fontSize: screenWidth > 600 ? 20 : 14,
                  ),
                ),
                child: screenWidth > 700
                    ? Text('Rechercher') // Si l'écran est large (texte)
                    : Icon(Icons.search,
                        color: Colors.blue), // Si l'écran est petit (icone)
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                    'assets/images/docare_logo2.png',
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
          buildTopBar(context), // Barre de recherche (voir la méthode buildTopBar)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(4.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (MediaQuery.of(context).size.width / 200)
                    .floor(), // le nobre d'éléments par ligne (adapté selon la taille de l'écran)
                crossAxisSpacing: 10.0, // Espace horizontal entre les éléments
                mainAxisSpacing: 10.0, // Espace vertical entre les éléments
              ),
              itemCount: 15, // Remplacer par le nombre réel de documents
              itemBuilder: (context, index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    // Code pour visualiser le document
                    onTap: () async {
                      //var document = documentsList[index]; // il faut créer une liste de documents
                      String document = index % 2 == 0 
                        ? 'assets/images/CNI_example.png' 
                        : 'assets/images/ordonnance-pharmacie-1.png';
                      //String fileName = document['name']; // Get the filename from the document data
                      String fileExtension = document.split('.').last; // Extract the file extension

                      if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
                        // It's an image
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Image.asset(document), // Use the path from the document data
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Fermer'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (fileExtension == 'pdf') {
                        final fileBytes = await loadPdfFromAssets(document); // Charge le pdf depuis les assets
                        _displayPdf(context, fileBytes); // Appelle la methode pour afficher le pdf
                        
                      } else {
                        print("Type de fichier non supporté pour la visualisation directe.");
                      }
                    },

                    child: GridTile(
                      footer: Container(
                        padding: const EdgeInsets.all(4.0),
                        color: Colors.blue.withOpacity(0.8),
                        child: Text(
                          'document_$index.pdf',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      child: index % 2 == 0 // Pour alterner les images
                          ? Image.asset(
                              'assets/images/CNI_example.png',
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/ordonnance-pharmacie-1.png',
                              fit: BoxFit.cover,
                            ),
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

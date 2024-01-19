
import 'package:flutter/material.dart';
import 'package:docare/main.dart';
import 'package:file_picker/file_picker.dart'; // Pour sélectionner un fichier
import 'dart:typed_data'; // Pour convertir un fichier en bytes
import 'package:docare/pdf_view_mobile.dart'; // Pour afficher un fichier PDF dans une nouvelle page
import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';
import 'package:docare/user.dart';
import 'package:docare/document.dart';

// imports pour open_filex (pour ouvrir les fichiers)
import 'package:open_filex/open_filex.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DocumentInterface extends StatelessWidget {

  // This method uses open_filex to open the file.
  void _openFile(Document file, BuildContext context) async {

    if(file.fileType == 'pdf') {
      // Si le document est un PDF
      final byteData = await rootBundle.load(file.path);
      final tempDir = await getTemporaryDirectory();
      final fileName = file.path.split('/').last;
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes), flush: true);

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
          content: Image.asset(file.path), // Assuming `path` is a valid asset path
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
                      } else {
                        // Handle the situation where bytes are not available
                        print('Error: File bytes are null');
                      }
                    } else if (file.extension == 'pdf') {
                      // Ne pas afficher le fichier PDF dans un dialogue
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
                    ? Text(
                        'Ajouter un document') // Si l'écran est large (texte)
                    : Icon(Icons.add,
                        color: Colors.blue), // Si l'écran est petit (icone)
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
    final userProvider = Provider.of<User>(context, listen: false);

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
          buildTopBar(
              context), // Barre de recherche (voir la méthode buildTopBar)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(4.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (MediaQuery.of(context).size.width / 200)
                    .floor(), // le nobre d'éléments par ligne (adapté selon la taille de l'écran)
                crossAxisSpacing: 10.0, // Espace horizontal entre les éléments
                mainAxisSpacing: 10.0, // Espace vertical entre les éléments
              ),
              itemCount: userProvider.documentList
                  .length, // Remplacer par le nombre réel de documents
              itemBuilder: (context, index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      // Code pour visualiser le document

                      // Vérifiez si le fichier est une image
                      Document file = userProvider.documentList[index];
                      _openFile(file, context);
                      
                    },
                    child: GridTile(
                      footer: Container(
                        padding: const EdgeInsets.all(4.0),
                        color: Colors.blue.withOpacity(0.8),
                        child: Text(
                          userProvider.documentList[index].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      child: userProvider.documentList[index].fileType ==
                              'img' // Si le document est une image
                          ? // Conditionally render the Image.asset widget
                          Image.asset(
                              userProvider.documentList[index].path,
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

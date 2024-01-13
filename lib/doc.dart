import 'package:flutter/material.dart';
import 'package:docare/main.dart';

class Document extends StatelessWidget {

  // Méthode pour construire la barre de recherche
  Widget buildTopBar(BuildContext context) {
    // Utilisez MediaQuery pour obtenir la largeur de l'écran
    double screenWidth = MediaQuery.of(context).size.width;

    // Déterminez la taille des boutons en fonction de la largeur de l'écran
    double buttonWidth = screenWidth > 600 ? 200 : screenWidth / 4;
    double padding = screenWidth > 600 ? 50.0 : 8.0;

    return Container(
      padding: EdgeInsets.all(padding),
      color: Colors.blue,
      child: Row(
        children: <Widget>[
          // Utilisez Flexible pour que le bouton "Ajouter un document" s'adapte à la taille de l'écran
          Flexible(
            child: ElevatedButton(
              onPressed: () {
                // Code pour ajouter un document
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                textStyle: TextStyle(
                    fontSize: screenWidth > 600
                        ? 20
                        : 14), // Ajustez la taille de la police en fonction de la largeur de l'écran
              ),
              child: const Text('Ajouter un document'),
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
            child: ElevatedButton(
              onPressed: () {
                // Code pour la recherche
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                textStyle: TextStyle(
                    fontSize: screenWidth > 600
                        ? 20
                        : 14), // Ajuster la taille de la police en fonction de la largeur de l'écran
              ),
              child: const Text('Rechercher'),
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
                    onTap: () {
                      // Code pour visualiser le document
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

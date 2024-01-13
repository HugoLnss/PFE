import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            const Text(
              'Bienvenue sur DOCare !',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
            ),
            const Text(
              'Votre application tri administratif intelligent',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            

            const Spacer(flex: 4),

            // Bouton pour la page 1 //
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                // style pour le bouton "Get Started !"
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Couleur de fond du bouton
                    foregroundColor: Color.fromARGB(255, 53, 0, 243), // Couleur du texte du bouton
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 17),
                  ),
                  child: const Text('Créer un compte', style: TextStyle(fontSize: 20)),
                ),
            ),
            
            // Espacement entre les boutons //
            const SizedBox(height: 20), 

            // Bouton pour la page de connexion //
            SizedBox(
              width: 300,
              child :ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                // style pour le bouton "Get Started !"
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Couleur de fond du bouton
                    foregroundColor: const Color.fromARGB(255, 53, 0, 243), // Couleur du texte du bouton
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 17),
                  ),
                  child: const Text('Connexion', style: TextStyle(fontSize: 20)),
                ),
            ),

            const Spacer(flex: 2)
          ],
          
        ),
      ),
    );
  }
}

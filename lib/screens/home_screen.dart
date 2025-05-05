import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invest IA Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bienvenue sur Invest IA!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/economic_calendar');
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text("Calendrier Économique"),
               style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), // Largeur maximale
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/news');
              },
              icon: const Icon(Icons.article),
              label: const Text("Actualités Financières"),
              style: ElevatedButton.styleFrom(
                 minimumSize: const Size(double.infinity, 50),
               ),
            ),
             const SizedBox(height: 10),
             // Bouton pour la liste d'actifs (fonctionne déjà)
             ElevatedButton.icon(
               onPressed: () {
                 Navigator.pushNamed(context, '/asset_list'); // Navigue vers la liste d'actifs
               },
               icon: const Icon(Icons.trending_up), // Icône pour les tendances/marché
               label: const Text("Marché des Actifs"),
               style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
             ),
             // Bouton pour un actif spécifique (CORRIGÉ pour utiliser un ID CoinGecko)
             const SizedBox(height: 10),
             ElevatedButton.icon(
               onPressed: () {
                 // ** CORRECTION : Passe l'ID CoinGecko "bitcoin" (ou un autre) **
                 Navigator.pushNamed(context, '/asset_detail', arguments: 'bitcoin');
               },
               icon: const Icon(Icons.show_chart),
               label: const Text("Détail Actif (Bitcoin)"), // Change aussi le label pour correspondre
               style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
             ),
          ],
        ),
      ),
    );
  }
}
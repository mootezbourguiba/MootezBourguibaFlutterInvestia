import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invest_ia/models/economic_event.dart'; // Nécessaire pour formater la date

class EconomicEventCard extends StatelessWidget {
  final EconomicEvent economicEvent;
  final VoidCallback? onTap; // Pour rendre la carte cliquable

  const EconomicEventCard({
    Key? key,
    required this.economicEvent,
    this.onTap,
  }) : super(key: key);

  // Helper pour obtenir la couleur de l'impact
  Color _getImpactColor(String impact) {
    switch (impact.toLowerCase()) { // Utilise toLowerCase pour gérer les variations (Haut, haut, HAUT)
      case 'haut':
        return Colors.red;
      case 'moyen':
        return Colors.orange;
      case 'faible':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
       margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
       elevation: 2.0,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(8.0),
       ),
      child: InkWell( // Rend la carte cliquable
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                economicEvent.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Date: ${DateFormat('yyyy-MM-dd').format(economicEvent.date)}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
               // Tu peux ajouter l'heure ici si ton modèle l'a
              // if (economicEvent.time != null) ...[
              //   const SizedBox(height: 4),
              //   Text(
              //      "Heure: ${economicEvent.time}",
              //      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              //   ),
              // ],
              const SizedBox(height: 8),
              Text(
                "Impact: ${economicEvent.impact}",
                style: TextStyle(
                  fontSize: 14,
                  color: _getImpactColor(economicEvent.impact), // Couleur dynamique
                  fontWeight: FontWeight.bold,
                ),
              ),
               // Tu peux ajouter Actual/Forecast/Previous ici si ton modèle l'a
              // if (economicEvent.actual != null || economicEvent.forecast != null || economicEvent.previous != null) ...[
              //    const SizedBox(height: 8),
              //    Text("Actual: ${economicEvent.actual?.toStringAsFixed(2) ?? '-'}"), // Utilise ?. et ?? pour gérer les nulls
              //    Text("Forecast: ${economicEvent.forecast?.toStringAsFixed(2) ?? '-'}"),
              //    Text("Previous: ${economicEvent.previous?.toStringAsFixed(2) ?? '-'}"),
              // ]
            ],
          ),
        ),
      ),
    );
  }
}
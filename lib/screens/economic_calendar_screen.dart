import 'package:flutter/material.dart';

class EconomicCalendarScreen extends StatelessWidget {
  final List<Map<String, String>> events = [
    {
      'date': '2025-04-28',
      'event': 'FOMC Meeting',
      'impact': 'Haut',
    },
    {
      'date': '2025-04-29',
      'event': 'Taux de Croissance PIB',
      'impact': 'Moyen',
    },
    {
      'date': '2025-04-30',
      'event': 'Taux de Chômage',
      'impact': 'Faible',
    },
    {
      'date': '2025-05-01',
      'event': 'Indice de Confiance des Consommateurs',
      'impact': 'Haut',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendrier Économique'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 20),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(event['event'] ?? ''),
                      content: Text('Date: ${event['date']}\nImpact: ${event['impact']}'),
                      actions: [
                        TextButton(
                          child: Text('Fermer'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  leading: Icon(Icons.event, size: 40, color: Colors.indigo),
                  title: Text(event['event'] ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Date: ${event['date']}', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                      Text('Impact: ${event['impact']}', style: TextStyle(color: Colors.black87)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

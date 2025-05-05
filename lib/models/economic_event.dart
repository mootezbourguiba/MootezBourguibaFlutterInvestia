import 'package:hive/hive.dart'; // Importe Hive

// Exécute: flutter packages pub run build_runner build
// Chaque fois que tu modifies cette classe
part 'economic_event.g.dart';

@HiveType(typeId: 1) // ID unique pour EconomicEvent (doit être différent de NewsArticle)
class EconomicEvent {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final String impact; // Haut, Moyen, Faible
  // Tu peux ajouter d'autres champs comme time, actual, forecast, previous, country
  // @HiveField(3)
  // final String? time;
  // @HiveField(4)
  // final double? actual; // Utilise double? si la valeur peut être absente
  // @HiveField(5)
  // final double? forecast;
  // @HiveField(6)
  // final double? previous;
  // @HiveField(7)
  // final String? country;

  EconomicEvent({
    required this.title,
    required this.date,
    required this.impact,
    // this.time,
    // this.actual,
    // this.forecast,
    // this.previous,
    // this.country,
  });

  // Methode factory pour créer un événement depuis un JSON (à adapter selon l'API)
  factory EconomicEvent.fromJson(Map<String, dynamic> json) {
    // Adapte la structure JSON ici
    return EconomicEvent(
      title: json['title'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      impact: json['impact'] as String? ?? 'Unknown',
      // time: json['time'] as String?,
      // actual: (json['actual'] as num?)?.toDouble(), // Gère le null et la conversion
      // forecast: (json['forecast'] as num?)?.toDouble(),
      // previous: (json['previous'] as num?)?.toDouble(),
      // country: json['country'] as String?,
    );
  }
}
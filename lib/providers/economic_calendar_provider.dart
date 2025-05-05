import 'package:flutter/foundation.dart';
import 'package:invest_ia/models/economic_event.dart';
import 'package:invest_ia/services/data_service.dart';

class EconomicCalendarProvider with ChangeNotifier {
  final DataService _dataService = DataService();

  List<EconomicEvent> _events = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<EconomicEvent> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchEvents() async {
    _isLoading = true;
    _errorMessage = null;
    // Ne pas notifier ici pour le loading si tu veux afficher le cache immédiatement.
    // Notifie seulement après avoir les données (cache ou API) ou l'erreur.
    // notifyListeners(); // Commenté si tu veux une approche "cache d'abord" rapide

    try {
      // Appelle la méthode du service qui gère le cache et l'API
      final fetchedEvents = await _dataService.fetchEconomicEventsWithCache(); // Utilise la nouvelle méthode
      _events = fetchedEvents;
      _errorMessage = null;
    } catch (e) {
       // L'erreur peut indiquer qu'il y a du cache affiché si la méthode du service la lève ainsi
      _errorMessage = "Failed to load economic events: ${e.toString()}";
      // Si le service retourne le cache en cas d'échec API, _events ne sera pas vide ici.
      // Si le service lève une exception et vide _events en cas d'échec, _events sera vide.
      // Adapte la gestion de _events = [] ici en fonction de la logique de ton service.
    } finally {
      _isLoading = false;
      notifyListeners(); // Notifie que l'état final est prêt (données ou erreur/cache)
    }
  }

  // TODO: Ajouter ici la logique pour les événements "suivis" et les notifications
  // List<EconomicEvent> _followedEvents = [];
  // void followEvent(EconomicEvent event) { ... }
  // void unfollowEvent(EconomicEvent event) { ... }
  // void scheduleNotification(EconomicEvent event) { ... }

}
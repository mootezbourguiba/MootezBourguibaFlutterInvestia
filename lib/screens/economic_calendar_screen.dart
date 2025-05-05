import 'package:flutter/material.dart';
import 'package:invest_ia/widgets/economic_event_card.dart';
import 'package:provider/provider.dart';
// import 'package:intl/intl.dart'; // Plus besoin si la Card gère le formatage
import 'package:invest_ia/providers/economic_calendar_provider.dart';
import 'package:invest_ia/models/economic_event.dart'; // Importe la nouvelle carte

class EconomicCalendarScreen extends StatefulWidget {
  const EconomicCalendarScreen({super.key});

  @override
  State<EconomicCalendarScreen> createState() => _EconomicCalendarScreenState();
}

class _EconomicCalendarScreenState extends State<EconomicCalendarScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
       Provider.of<EconomicCalendarProvider>(context, listen: false).fetchEvents();
    });
  }

  // Helper pour obtenir la couleur de l'impact (peut aussi être dans la carte)
  // Color _getImpactColor(String impact) { ... } // Plus besoin ici si dans la carte

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EconomicCalendarProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendrier Économique"),
        leading: IconButton(
           icon: const Icon(Icons.arrow_back),
           onPressed: () {
             Navigator.pop(context);
           },
         ),
      ),
      body: Center(
        child: provider.isLoading
            ? const CircularProgressIndicator()
            : provider.errorMessage != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 50), // Utilise const
                        const SizedBox(height: 10),
                        Text(
                           provider.errorMessage!,
                           textAlign: TextAlign.center,
                           style: const TextStyle(color: Colors.red, fontSize: 16), // Utilise const
                         ),
                         const SizedBox(height: 20),
                         ElevatedButton(
                            onPressed: () => provider.fetchEvents(),
                            child: const Text("Réessayer"), // Utilise const
                         ),
                      ],
                    ),
                  )
                : provider.events.isEmpty
                    ? const Text("Aucun événement économique disponible.") // Utilise const
                    : RefreshIndicator(
                        onRefresh: () => provider.fetchEvents(),
                        child: ListView.builder(
                          itemCount: provider.events.length,
                          itemBuilder: (context, index) {
                            final event = provider.events[index];
                            // ** Utilise le nouveau widget EconomicEventCard **
                            return EconomicEventCard(
                              economicEvent: event,
                              // Tu peux ajouter un onTap callback ici si tu veux les rendre cliquables
                              // onTap: () { /* navigue vers détails */ },
                            );
                          },
                        ),
                      ),
      ),
    );
  }
}
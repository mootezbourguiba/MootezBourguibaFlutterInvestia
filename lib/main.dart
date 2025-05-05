import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Importe Hive Flutter
import 'package:path_provider/path_provider.dart'; // Pour trouver le chemin de stockage Hive

// Importe tes écrans et providers
import 'screens/home_screen.dart';
import 'screens/economic_calendar_screen.dart';
import 'screens/news_screen.dart';
import 'screens/asset_list_screen.dart';
import 'screens/asset_detail_screen.dart';

import 'providers/economic_calendar_provider.dart';
import 'providers/news_provider.dart';
import 'providers/market_data_provider.dart';

// --- CORRECTION 1 : Retire les imports des fichiers .g.dart ---
// import 'models/news_article.g.dart'; // SUPPRIME CETTE LIGNE
// import 'models/economic_event.g.dart'; // SUPPRIME CETTE LIGNE
// import 'models/asset.g.dart'; // SUPPRIME CETTE LIGNE

// Importe les fichiers modèles eux-mêmes. Les Adapters sont disponibles via Hive.registerAdapter
import 'models/news_article.dart';
import 'models/economic_event.dart';
import 'models/asset.dart';


// Rend main asynchrone pour initialiser Hive
Future<void> main() async {
  // Assure-toi que les bindings Flutter sont initialisés avant d'utiliser des plugins (comme path_provider ou hive_flutter)
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Hive Flutter (trouve automatiquement le bon chemin)
  await Hive.initFlutter();

  // Enregistre les adapters générés par hive_generator
  // Ces adapters permettent à Hive de sérialiser/désérialiser tes objets Dart
  // CORRECTION : Assure-toi que ces adaptateurs sont correctement générés par build_runner
  // Les noms des adaptateurs sont générés dans les fichiers .g.dart
  Hive.registerAdapter(NewsArticleAdapter());
  Hive.registerAdapter(EconomicEventAdapter()); // Si tu mets EconomicEvent en cache
  Hive.registerAdapter(AssetAdapter()); // Si tu mets Asset en cache

  // Optionnel: Ouvre les "boxes" (similaires à des tables) au démarrage ici ou dans tes services/providers
  // Les ouvrir ici assure qu'ils sont prêts dès le démarrage
  // try {
  //   await Hive.openBox<NewsArticle>('newsBox');
  //   await Hive.openBox<EconomicEvent>('economicCalendarBox');
  //   await Hive.openBox<Asset>('assetsBox');
  // } catch (e) {
  //    print("Erreur lors de l'ouverture des boxes Hive: $e");
  // }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EconomicCalendarProvider()),
        ChangeNotifierProvider(create: (context) => NewsProvider()),
        ChangeNotifierProvider(create: (context) => MarketDataProvider()),
        // Ajoute ici les autres providers
      ],
      child: MaterialApp(
        title: 'Invest IA',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F7FA),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 2,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
          ),
          cardTheme: CardTheme(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        routes: {
          '/': (context) => const HomeScreen(),
          '/economic_calendar': (context) => const EconomicCalendarScreen(),
          '/news': (context) => const NewsScreen(),
          '/asset_list': (context) => const AssetListScreen(),
          // Route pour le détail d'un actif, nécessite de passer l'ID en argument
          '/asset_detail': (context) {
             final assetId = ModalRoute.of(context)?.settings.arguments as String?;
             if (assetId == null) {
                // CORRECTION 2 : Retire le 'const' avant Scaffold
                return Scaffold(
                   // CORRECTION 2 : Ajoute 'const' aux widgets internes si possible
                   appBar: AppBar(title: const Text("Erreur")),
                   body: const Center(child: Text("ID d'actif manquant.")),
                );
             }
             // CORRECTION 3 : Utilise le bon nom de paramètre 'assetId'
             return AssetDetailScreen(assetId: assetId); // Passe l'ID non-null
           },
           // Ajoute les routes pour les autres écrans
        },
        initialRoute: '/',
      ),
    );
  }
}
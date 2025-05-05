import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
// Optionnel: Importe connectivity_plus si tu l'utilises
// import 'package:connectivity_plus/connectivity_plus.dart';
// Retire l'import de EconomicEvent car le modèle n'est plus utilisé pour cette fonctionnalité
// import 'package:invest_ia/models/economic_event.dart'; // <-- LIGNE SUPPRIMÉE

// Garde les imports pour les actualités et les assets si tu conserves ces fonctionnalités
import 'package:invest_ia/models/news_article.dart'; // Assure-toi que le chemin est correct
import 'package:invest_ia/models/asset.dart'; // Importe le modèle Asset - Assure-toi que le chemin est correct et que le modèle a les bons champs/fromjson

// intl n'est plus strictement nécessaire dans ce fichier si tu ne formates plus les dates
// pour l'API du calendrier, mais garde-le si tes autres méthodes l'utilisent.
import 'package:intl/intl.dart';


class DataService {
   // Clé API Finnhub pour les actualités (gardée car la fonctionnalité actualités semble fonctionner)
   final String _finnhubApiKey = 'd0bvhm9r01qs9fjjltpgd0bvhm9r01qs9fjjltq0';
   final String _finnhubBaseUrl = 'https://finnhub.io/api/v1';

   // Retire les constantes associées à Trading Economics si tu ne l'utilises que pour le calendrier
   // final String _teClientKey = '...'; // <-- LIGNE SUPPRIMÉE
   // final String _teClientSecret = '...'; // <-- LIGNE SUPPRIMÉE
   // final String _teBaseUrl = '...'; // <-- LIGNE SUPPRIMÉE


   // CoinGecko Base URL (pour les données de marché crypto)
   final String _coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3';
   // Pas de clé API nécessaire pour les endpoints publics CoinGecko que nous utilisons ici

   // Méthode générique pour gérer les appels HTTP et les erreurs
   // Cette méthode est conservée car elle est utilisée par d'autres fonctionnalités (News, Market)
   Future<dynamic> _fetchData(Uri url, {Map<String, String>? headers}) async { // Garde headers optionnel au cas où d'autres APIs l'exigent
       print("Fetching data from: $url");
       final client = http.Client();

       try {
           final response = await client.get(url, headers: headers); // Utilise headers

           if (response.statusCode == 200) {
               print("Successfully fetched data from: $url");
               if (response.body.isEmpty) {
                  print("Warning: Received empty body for $url with status 200.");
                  return null;
               }
               return jsonDecode(response.body);
           } else {
               print("HTTP Error ${response.statusCode}: ${response.reasonPhrase} for $url");
               print("Response body: ${response.body.substring(0, response.body.length.clamp(0, 500))}");
               throw Exception('HTTP Error ${response.statusCode}: ${response.reasonPhrase}');
           }
       } catch (e) {
           print("Network or Parsing Error for $url: ${e.toString()}");
           throw Exception('Network or Parsing Error: ${e.toString()}');
       } finally {
         client.close();
       }
   }


   // --- Actualités ---
   // Cette méthode reste inchangée car tu conserves la fonctionnalité actualités via Finnhub
   Future<List<NewsArticle>> fetchNewsArticlesWithCache() async {
       const boxName = 'newsBox';
       final box = await Hive.openBox<NewsArticle>(boxName);
       final cachedArticles = box.values.toList();

       if (cachedArticles.isNotEmpty) {
           print("Attempting to load news from cache (${cachedArticles.length} items)");
       }

       try {
           print("Fetching news from Finnhub API...");
           final url = Uri.parse('$_finnhubBaseUrl/news?category=general&token=$_finnhubApiKey');
           final jsonResponse = await _fetchData(url);
           final List<dynamic> articlesJson = jsonResponse as List<dynamic>? ?? [];

           final freshArticles = articlesJson
               .where((item) => item is Map<String, dynamic>)
               .map((json) => NewsArticle.fromJson(json as Map<String, dynamic>))
               .toList();

           await box.clear();
           await box.addAll(freshArticles);
           print("Successfully fetched news from API and updated cache (${freshArticles.length} items)");

           return freshArticles;

       } catch (e) {
           print("Failed to fetch fresh news from API: ${e.toString()}");

           if (cachedArticles.isNotEmpty) {
               print("Returning cached news instead.");
               return cachedArticles;
           } else {
               print("No cache available for news. Throwing error.");
               throw Exception('Failed to load news and no cache available: ${e.toString()}');
           }
       } finally {
         if (box.isOpen) {
            await box.close();
         }
       }
   }

   // --- Calendrier Économique ---
   // SUPPRIMÉ : Retire toute la méthode fetchEconomicEventsWithCache car la fonctionnalité est retirée.
   /*
   Future<List<EconomicEvent>> fetchEconomicEventsWithCache() async {
       // ... (tout le code de cette méthode est supprimé)
   }
   */


  // --- Données de Marché (CoinGecko) ---
  // Ces méthodes restent inchangées car tu conserves la fonctionnalité de données de marché.

  // Récupère une liste d'actifs (utilise CoinGecko /coins/markets)
  Future<List<Asset>> fetchMarketAssets() async {
       print("Fetching market assets from CoinGecko...");
       final url = Uri.parse('$_coinGeckoBaseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false');

       try {
           final jsonResponse = await _fetchData(url);
           final List<dynamic> assetsJson = jsonResponse as List<dynamic>? ?? [];

           return assetsJson
               .where((item) => item is Map<String, dynamic>)
               .map((json) => Asset.fromJson(json as Map<String, dynamic>))
               .toList();
       } catch(e) {
            print("Error fetching market assets from CoinGecko: $e");
            throw Exception("Failed to load market assets: $e");
       }
  }

  // Récupère les données (prix, changement) d'un seul actif (utilise CoinGecko /coins/{id})
  Future<Asset> fetchAssetPrice(String id) async {
       print("Fetching price for $id from CoinGecko...");
       final url = Uri.parse('$_coinGeckoBaseUrl/coins/$id?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false');

        try {
           final jsonResponse = await _fetchData(url);

            if (jsonResponse == null || jsonResponse is! Map<String, dynamic>) {
                throw Exception("Invalid or unexpected JSON response for $id");
            }

            final marketDataJson = jsonResponse['market_data'];
            if (marketDataJson is! Map<String, dynamic>) {
                 throw Exception("Market data not available or in unexpected format for $id");
            }

            final currentPriceJson = marketDataJson['current_price'];
             double currentPrice = 0.0;
             if (currentPriceJson is Map<String, dynamic>) {
               currentPrice = (currentPriceJson['usd'] as num?)?.toDouble() ?? 0.0;
             } else {
                print("Warning: 'current_price' field not a map or missing for $id");
             }

            final priceChange24hJsonFull = marketDataJson['price_change_24h_in_currency'];
            final priceChangePercentage24hJsonFull = marketDataJson['price_change_percentage_24h_in_currency'];

            double priceChange24h = 0.0;
            if (priceChange24hJsonFull is Map<String, dynamic>) {
                priceChange24h = (priceChange24hJsonFull['usd'] as num?)?.toDouble() ?? 0.0;
            } else {
                print("Warning: 'price_change_24h_in_currency' field not a map or missing for $id");
            }

            double priceChangePercentage24h = 0.0;
            if (priceChangePercentage24hJsonFull is Map<String, dynamic>) {
                 priceChangePercentage24h = (priceChangePercentage24hJsonFull['usd'] as num?)?.toDouble() ?? 0.0;
            } else {
                 print("Warning: 'price_change_percentage_24h_in_currency' field not a map or missing for $id");
            }

            final coinId = jsonResponse['id'] as String? ?? '';
            final symbol = jsonResponse['symbol'] as String? ?? '';
            final name = jsonResponse['name'] as String? ?? '';
             final imageJson = jsonResponse['image'];
             String imageUrl = '';
             if (imageJson is Map<String, dynamic>) {
                imageUrl = (imageJson['large'] as String?) ?? '';
             } else {
                 print("Warning: 'image' field not a map or missing for $id");
             }

            final asset = Asset(
                 id: coinId,
                 symbol: symbol,
                 name: name,
                 imageUrl: imageUrl,
                 currentPrice: currentPrice,
                 priceChange24h: priceChange24h,
                 priceChangePercentage24h: priceChangePercentage24h,
             );

            print("Fetched price for ${asset.symbol}: ${asset.currentPrice}");
            return asset;

        } catch(e) {
            print("Error fetching single asset price for $id from CoinGecko: $e");
            throw Exception("Failed to load price for $id: $e");
        }
  }

   // --- Gestion de Hive (Adapters) ---
   // Mets à jour ce commentaire pour refléter les adapters que tu utilises réellement
   // N'oublie pas d'enregistrer les adapters Hive pour NewsArticle et Asset
   // dans ta fonction main() ou avant d'ouvrir les boîtes pour la première fois.
   // Exemple dans main.dart (ou un fichier d'initialisation) :
   /*
   void main() async {
     WidgetsFlutterBinding.ensureInitialized(); // Nécessaire si Hive est initialisé avant runApp
     await Hive.initFlutter();
     Hive.registerAdapter<NewsArticle>(NewsArticleAdapter()); // Génère NewsArticleAdapter
     // Retire l'enregistrement de EconomicEventAdapter
     // Hive.registerAdapter<EconomicEvent>(EconomicEventAdapter()); // <-- LIGNE SUPPRIMÉE
     Hive.registerAdapter<Asset>(AssetAdapter()); // Génère AssetAdapter si tu caches des Assets complets

     runApp(const MyApp());
   }
   */
   // Tu auras besoin des annotations @HiveType et @HiveField sur tes modèles restants (NewsArticle, Asset)
   // et de lancer `flutter packages pub run build_runner build` pour générer leurs adapters.

}
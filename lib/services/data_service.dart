import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
// Optionnel: Importe connectivity_plus si tu l'utilises
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:invest_ia/models/economic_event.dart';
import 'package:invest_ia/models/news_article.dart';
import 'package:invest_ia/models/asset.dart'; // Importe le modèle Asset
import 'package:intl/intl.dart'; // Nécessaire pour formater les dates/périodes pour l'API


class DataService {
   // Clé API Finnhub pour les actualités et le calendrier économique
   final String _finnhubApiKey = 'd0bvhm9r01qs9fjjltpgd0bvhm9r01qs9fjjltq0'; // <-- TA VRAIE CLÉ FINNHUB
   final String _finnhubBaseUrl = 'https://finnhub.io/api/v1'; // <-- URL Finnhub

   // CoinGecko Base URL (pour les données de marché crypto)
   final String _coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3';
   // Pas de clé API nécessaire pour les endpoints publics CoinGecko que nous utilisons ici

   // Méthode générique pour gérer les appels HTTP et les erreurs
   Future<dynamic> _fetchData(Uri url) async {
       print("Fetching data from: $url"); // Utile pour le debug
       try {
           final response = await http.get(url);

           if (response.statusCode == 200) {
               return jsonDecode(response.body);
           } else {
               // Gérer les erreurs spécifiques de l'API (clés invalides, limites atteintes, etc.)
               print("HTTP Error ${response.statusCode}: ${response.reasonPhrase}");
               throw Exception('HTTP Error ${response.statusCode}: ${response.reasonPhrase}');
           }
       } catch (e) {
           // Gérer les erreurs réseau ou parsing JSON
           print("Network or Parsing Error: ${e.toString()}");
           throw Exception('Network or Parsing Error: ${e.toString()}');
       }
   }


   // --- Actualités ---

   // Récupère les actualités avec gestion du cache (utilise Finnhub)
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
           final freshArticles = articlesJson.map((json) => NewsArticle.fromJson(json as Map<String, dynamic>)).toList();

           await box.clear();
           await box.addAll(freshArticles);
           print("Successfully fetched news from API and updated cache (${freshArticles.length} items)");

           await box.close();
           return freshArticles;

       } catch (e) {
           print("Failed to fetch news from API: ${e.toString()}");
           await box.close();

           if (cachedArticles.isNotEmpty) {
               print("API failed, returning cached news from cache.");
               throw Exception('API Error, showing cached data: ${e.toString()}');
           } else {
               print("API failed and no cache available.");
               throw Exception('Failed to load news from API and no cache available: ${e.toString()}');
           }
       }
   }

   // --- Calendrier Économique ---

   // Récupère les événements avec gestion du cache (utilise Finnhub)
   Future<List<EconomicEvent>> fetchEconomicEventsWithCache() async {
        const boxName = 'economicCalendarBox';
        final box = await Hive.openBox<EconomicEvent>(boxName);
        final cachedEvents = box.values.toList();

        if (cachedEvents.isNotEmpty) {
            print("Attempting to load economic events from cache (${cachedEvents.length} items)");
        }

        try {
            print("Fetching economic events from Finnhub API...");
             final now = DateTime.now();
             final future = now.add(const Duration(days: 90));
             final from = DateFormat('yyyy-MM-dd').format(now);
             final to = DateFormat('yyyy-MM-dd').format(future);

            final url = Uri.parse('$_finnhubBaseUrl/calendar/economic?from=$from&to=$to&token=$_finnhubApiKey');
            final jsonResponse = await _fetchData(url);

            final List<dynamic> eventsJson = jsonResponse['economicCalendar'] as List<dynamic>? ?? []; // Clé 'economicCalendar' pour Finnhub

            final freshEvents = eventsJson.map((json) => EconomicEvent.fromJson(json as Map<String, dynamic>)).toList();

            await box.clear();
            await box.addAll(freshEvents);
            print("Successfully fetched economic events from API and updated cache (${freshEvents.length} items)");

            await box.close();
            return freshEvents;

        } catch (e) {
            print("Failed to fetch economic events from API: ${e.toString()}");
            await box.close();

             if (cachedEvents.isNotEmpty) {
                print("API failed, returning cached economic events from cache.");
                throw Exception('API Error, showing cached data: ${e.toString()}');
             } else {
                print("API failed and no cache available.");
                throw Exception('Failed to load economic events from API and no cache available: ${e.toString()}');
             }
        }
   }


  // --- Données de Marché (CoinGecko) ---
  // Ces méthodes fonctionnent déjà selon la console/screenshots.

  // Récupère une liste d'actifs (utilise CoinGecko /coins/markets)
  Future<List<Asset>> fetchMarketAssets() async {
       print("Fetching market assets from CoinGecko...");
       final url = Uri.parse('$_coinGeckoBaseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false');

       try {
           final jsonResponse = await _fetchData(url);
           final List<dynamic> assetsJson = jsonResponse as List<dynamic>? ?? [];
           return assetsJson.map((json) => Asset.fromJson(json as Map<String, dynamic>)).toList();
       } catch(e) {
            print("Error fetching market assets from CoinGecko: $e");
            throw Exception("Failed to load market assets: $e");
       }
  }

  // Récupère les données (prix, changement) d'un seul actif (utilise CoinGecko /coins/{id})
  Future<Asset> fetchAssetPrice(String id) async { // Utilise l'ID de CoinGecko (ex: "bitcoin")
       print("Fetching price for $id from CoinGecko...");
       final url = Uri.parse('$_coinGeckoBaseUrl/coins/$id?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false');

        try {
           final jsonResponse = await _fetchData(url);
            final marketDataJson = jsonResponse['market_data'] as Map<String, dynamic>?;

            if (marketDataJson == null) {
                 throw Exception("Market data not available in response for $id");
            }

            final currentPrice = (marketDataJson['current_price']?['usd'] as num?)?.toDouble() ?? 0.0;
            final priceChange24h = (marketDataJson['price_change_24h']?['usd'] as num?)?.toDouble() ?? 0.0;
            final priceChangePercentage24h = (marketDataJson['price_change_percentage_24h']?['usd'] as num?)?.toDouble() ?? 0.0;

            final coinId = jsonResponse['id'] as String? ?? '';
            final symbol = jsonResponse['symbol'] as String? ?? '';
            final name = jsonResponse['name'] as String? ?? '';
            final imageUrl = jsonResponse['image']?['large'] as String? ?? '';

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

   // Optionnel: startWebSocketPriceUpdates
}
import 'package:flutter/material.dart';
import '../widgets/price_card.dart';
import '../services/api_service.dart';
import '../models/market_data.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  List<MarketData> marketData = [];

  @override
  void initState() {
    super.initState();
    fetchMarketData();
  }

  void fetchMarketData() async {
    marketData = await ApiService.fetchMarketData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Market Prices')),
      body: ListView.builder(
        itemCount: marketData.length,
        itemBuilder: (context, index) {
          return PriceCard(marketData: marketData[index]);
        },
      ),
    );
  }
}

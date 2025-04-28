import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  final List<Map<String, String>> newsArticles = [
    {
      'title': 'Stock Market Updates',
      'description': 'The stock market saw a significant rise today as major indices...',
      'date': '2025-04-28',
    },
    {
      'title': 'GDP Growth Rate Expected to Slow',
      'description': 'The government has announced that GDP growth will slow in the upcoming quarter...',
      'date': '2025-04-27',
    },
    {
      'title': 'Interest Rates to Increase Soon',
      'description': 'The Federal Reserve has hinted at an upcoming interest rate hike...',
      'date': '2025-04-26',
    },
    {
      'title': 'Unemployment Rate Drops Again',
      'description': 'The unemployment rate has decreased for the second consecutive month...',
      'date': '2025-04-25',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualités'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: newsArticles.length,
        itemBuilder: (context, index) {
          final article = newsArticles[index];
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
                      title: Text(article['title'] ?? ''),
                      content: Text(article['description'] ?? ''),
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
                  leading: Icon(Icons.article, size: 40, color: Colors.indigo),
                  title: Text(article['title'] ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Date: ${article['date']}', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                      Text(article['description'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
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

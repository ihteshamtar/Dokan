import 'package:flutter/material.dart';

class Notificationscren extends StatelessWidget {
  const Notificationscren({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for notifications
    final notifications = List.generate(
      7,
      (index) => {
        'title': 'Flash Sale Alert!',
        'time': '1 Day Ago',
        'description':
            'Don\'t miss out on our one-day only flash sale! Get 20% off all Products.',
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notification',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w700),),

      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20.0), // Padding on all sides
        itemCount: notifications.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: 15), // Space between items
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF0F6),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/discount1.png',
                  width: 48, // Corrected width to prevent overflow
                  height: 48, // Corrected height for better aspect ratio
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification['title']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            notification['time']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        notification['description']!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

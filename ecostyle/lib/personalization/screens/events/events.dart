import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:ecostyle/models/event_model.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  bool _isConnected = true;
  final List<Event> _localEvents = []; // Local in-memory cache

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  // Check connectivity status
  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });

    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      setState(() {
        _isConnected = connectivityResult != ConnectivityResult.none;
      });
    });
  }

  // Fetch events
  Future<List<Event>> _fetchEvents() async {
    try {
      print('Checking connectivity: $_isConnected');

      if (!_isConnected) {
        // Return local in-memory events when offline
        print('No internet connection, returning local events');
        return _localEvents;
      } else {
        // Fetch online events from Firestore
        print('Fetching online events from Firestore');
        final snapshot = await FirebaseFirestore.instance
            .collection('events')
            .where('date', isGreaterThan: Timestamp.now()) // Fetch future events
            .orderBy('date')
            .get();

        print('Fetched snapshot: ${snapshot.docs.length} events found');

        // Map Firestore data to Event objects
        final onlineEvents = snapshot.docs.map((doc) {
          final data = doc.data();
          return Event(
            id: doc.id,
            title: data['title'] ?? '',
            description: data['description'] ?? '',
            date: (data['date'] as Timestamp).toDate(),
            location: data['location'] ?? '',
            imageUrl: data['imageUrl'] ?? '',
            tags: List<String>.from(data['tags'] ?? []),
          );
        }).toList();

        print('Mapped events: ${onlineEvents.length} events');

        // Sync online events to local in-memory storage
        _localEvents
          ..clear()
          ..addAll(onlineEvents);

        return onlineEvents;
      }
    } catch (e, stackTrace) {
      debugPrint('Error in _fetchEvents: $e\n$stackTrace');
      throw Exception('Failed to fetch events. Please try again later.');
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0'); // Ensures two digits for day
    final month = date.month.toString().padLeft(2, '0'); // Ensures two digits for month
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0'); // Ensures two digits for hour
    final minute = date.minute.toString().padLeft(2, '0'); // Ensures two digits for minute
    final second = date.second.toString().padLeft(2, '0'); // Optional: to include seconds

    // Format as "DD/MM/YYYY HH:mm"
    return '$day/$month/$year $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF012826), // Set the background color to green
      appBar: AppBar(
        title: Text('Upcoming Events'),
        automaticallyImplyLeading: false, // Removes the back arrow
      ),
      body: FutureBuilder<List<Event>>(
        future: _fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No upcoming events found. Please try again later.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final events = snapshot.data!;
          print('Fetched Events: $events');
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: event.imageUrl.isNotEmpty
                      ? Image.network(event.imageUrl, width: 50, height: 50)
                      : null,
                  title: Text(event.title),
                  subtitle: Text(
                    '${_formatDate(event.date)} at ${event.location}\n${event.description}',
                  ),
                  onTap: () {
                    // Navigate to event details
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

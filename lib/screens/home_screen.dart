import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_travel_planner/screens/auth/login_screen.dart';
import 'package:ai_travel_planner/screens/create_trip/place_search_screen.dart';
import 'package:ai_travel_planner/screens/create_trip/travelers_selection_screen.dart';
import 'package:ai_travel_planner/screens/create_trip/date_selection_screen.dart';
import 'package:ai_travel_planner/screens/create_trip/budget_selection_screen.dart';
import 'package:ai_travel_planner/screens/create_trip/trip_review_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _navigateToCreateTrip(BuildContext context) async {
    final placeResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PlaceSearchScreen(),
      ),
    );

    if (placeResult != null) {
      if (context.mounted) {
        final travelerResult = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TravelersSelectionScreen(
              placeDetails: placeResult,
            ),
          ),
        );

        if (travelerResult != null) {
          if (context.mounted) {
            final dateResult = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DateSelectionScreen(
                  tripDetails: travelerResult,
                ),
              ),
            );

            if (dateResult != null) {
              if (context.mounted) {
                final budgetResult = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BudgetSelectionScreen(
                      tripDetails: dateResult,
                    ),
                  ),
                );

                if (budgetResult != null) {
                  if (context.mounted) {
                    final reviewResult = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripReviewScreen(
                          tripDetails: budgetResult,
                        ),
                      ),
                    );

                    if (reviewResult != null) {
                      // TODO: Handle the generated trip plan
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'AI Travel Planner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('trips')
            .where('userId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final trips = snapshot.data?.docs ?? [];

          if (trips.isEmpty) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.1),
                        Colors.white,
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.flight_takeoff,
                          size: 64,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Start Your Journey',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Create your first trip and let AI\nplan the perfect itinerary for you',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () => _navigateToCreateTrip(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Create New Trip'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // TODO: Show list of trips
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreateTrip(context),
        label: const Text('New Trip'),
        icon: const Icon(Icons.add),
      ),
    );
  }
} 
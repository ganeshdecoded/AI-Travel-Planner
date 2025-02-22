import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class TripPlanScreen extends StatefulWidget {
  final Map<String, dynamic> tripDetails;

  const TripPlanScreen({
    super.key,
    required this.tripDetails,
  });

  @override
  State<TripPlanScreen> createState() => _TripPlanScreenState();
}

class _TripPlanScreenState extends State<TripPlanScreen> {
  late Future<Map<String, dynamic>> _tripPlan;

  @override
  void initState() {
    super.initState();
    _tripPlan = _generateTripPlan();
  }

  Future<Map<String, dynamic>> _generateTripPlan() async {
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: 'AIzaSyDdQWIl6318o_x3jMu4XNxA804StM372GA',
    );

    final prompt = '''
    Create a detailed travel itinerary for a ${widget.tripDetails['travelType']} trip to ${widget.tripDetails['description']} with a ${widget.tripDetails['budgetType']} budget.
    The trip duration is ${widget.tripDetails['endDate'].difference(widget.tripDetails['startDate']).inDays + 1} days.
    Include:
    1. Brief introduction about the destination
    2. Daily itinerary with morning, afternoon, and evening activities
    3. Recommended local restaurants and cuisine
    4. Must-visit attractions
    5. Travel tips and cultural considerations
    6. Estimated daily expenses in INR
    Format the response in JSON with the following structure:
    {
      "introduction": "text",
      "dailyItinerary": [{"day": 1, "morning": "", "afternoon": "", "evening": ""}],
      "restaurants": [{"name": "", "cuisine": "", "priceRange": ""}],
      "attractions": [{"name": "", "description": ""}],
      "tips": ["tip1", "tip2"],
      "expenses": {"accommodation": "", "food": "", "activities": "", "transport": ""}
    }
    ''';

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      final content = await model.generateContent([Content.text(prompt)]);
      final response = content.text ?? '';
      
      if (response.isEmpty) {
        return _getFallbackTripPlan();
      }
      
      try {
        return Map<String, dynamic>.from(json.decode(response));
      } catch (e) {
        return _getFallbackTripPlan();
      }
    } catch (e) {
      return _getFallbackTripPlan();
    }
  }

  Map<String, dynamic> _getFallbackTripPlan() {
    final int tripDays = widget.tripDetails['endDate']
        .difference(widget.tripDetails['startDate'])
        .inDays + 1;

    List<Map<String, dynamic>> generateDailyItinerary() {
      List<List<String>> activities = [
        [
          'Visit historical monuments and temples',
          'Explore local markets and shopping areas',
          'Experience traditional cultural shows'
        ],
        [
          'Adventure activities and outdoor sports',
          'Visit theme parks or entertainment zones',
          'Enjoy nightlife and modern entertainment'
        ],
        [
          'Nature walks and scenic spots',
          'Food tours and cooking classes',
          'Relaxation at spa or wellness centers'
        ],
        [
          'Museum and art gallery visits',
          'Local handicraft workshops',
          'Street food exploration'
        ],
        [
          'Photography tours',
          'Heritage walks',
          'Sunset viewing points'
        ],
      ];

      return List.generate(tripDays, (index) {
        final dayActivities = activities[index % activities.length];
        return {
          "day": index + 1,
          "morning": dayActivities[0],
          "afternoon": dayActivities[1],
          "evening": dayActivities[2],
          "image": "https://source.unsplash.com/featured/?${widget.tripDetails['description']},travel,day${index + 1}"
        };
      });
    }

    return {
      "introduction": "Welcome to ${widget.tripDetails['description']}! "
          "This vibrant destination offers a perfect blend of culture, cuisine, and attractions "
          "that make it ideal for a ${widget.tripDetails['travelType'].toLowerCase()} trip.",
      "dailyItinerary": generateDailyItinerary(),
      "restaurants": [
        {
          "name": "Local Delights Restaurant",
          "cuisine": "Traditional",
          "priceRange": "₹500-1500"
        },
        {
          "name": "Modern Fusion Café",
          "cuisine": "Contemporary",
          "priceRange": "₹1000-2000"
        },
        {
          "name": "Street Food Market",
          "cuisine": "Local Street Food",
          "priceRange": "₹100-500"
        }
      ],
      "attractions": [
        {
          "name": "Historical Center",
          "description": "Explore the rich history and architecture"
        },
        {
          "name": "Local Markets",
          "description": "Experience the vibrant shopping culture"
        },
        {
          "name": "Cultural Shows",
          "description": "Enjoy traditional performances and arts"
        }
      ],
      "tips": [
        "Research local customs and traditions before visiting",
        "Try the local cuisine for authentic experiences",
        "Use public transport for better city exploration",
        "Carry necessary documents and emergency contacts"
      ],
      "expenses": {
        "accommodation": widget.tripDetails['budgetType'] == 'Budget' 
            ? "₹1,000-2,000" 
            : widget.tripDetails['budgetType'] == 'Moderate'
                ? "₹3,000-5,000"
                : "₹8,000+",
        "food": "₹500-1,500 per day",
        "activities": "₹1,000-3,000 per day",
        "transport": "₹500-1,000 per day"
      }
    };
  }

  Widget _buildDayCard(Map<String, dynamic> day) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<List<String>>(
            future: _getPlacePhotos(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final photoUrl = snapshot.data![day['day'] % snapshot.data!.length];
                return ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    photoUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildDefaultHeader(day),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildDefaultHeader(day);
                    },
                  ),
                );
              }
              return _buildDefaultHeader(day);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Day ${day['day']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                _buildTimeSlot('Morning', day['morning']),
                _buildTimeSlot('Afternoon', day['afternoon']),
                _buildTimeSlot('Evening', day['evening']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String time, String activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$time: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(child: Text(activity)),
        ],
      ),
    );
  }

  Widget _buildRestaurants(List<dynamic> restaurants) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.restaurant, color: Colors.orange),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Recommended Restaurants',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.orange.shade300,
                                Colors.orange.shade700,
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.restaurant_menu,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                restaurant['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                restaurant['cuisine'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  restaurant['priceRange'],
                                  style: TextStyle(
                                    color: Colors.orange.shade800,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildAttractions(List<dynamic> attractions) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.attractions, color: Colors.purple),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Must-Visit Attractions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: attractions.length,
              itemBuilder: (context, index) {
                final attraction = attractions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.place,
                        color: Colors.purple.shade700,
                      ),
                    ),
                    title: Text(
                      attraction['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      attraction['description'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTips(List<dynamic> tips) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb),
                SizedBox(width: 8),
                Text(
                  'Travel Tips',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...tips.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(tip)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenses(Map<String, dynamic> expenses) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.currency_rupee),
                SizedBox(width: 8),
                Text(
                  'Estimated Expenses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...expenses.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('₹${entry.value}'),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _tripPlan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tripPlan = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    widget.tripDetails['description'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                      // Decorative travel icons pattern
                      Positioned.fill(
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                          ),
                          itemCount: 24,
                          itemBuilder: (context, index) {
                            final icons = [
                              Icons.flight_takeoff,
                              Icons.hotel,
                              Icons.restaurant,
                              Icons.photo_camera,
                              Icons.location_on,
                              Icons.directions_car,
                            ];
                            return Icon(
                              icons[index % icons.length],
                              size: 20,
                              color: Colors.white.withOpacity(0.2),
                            );
                          },
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      // Trip summary
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 60,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildSummaryItem(
                                Icons.group,
                                widget.tripDetails['travelType'],
                              ),
                              const SizedBox(width: 12),
                              _buildSummaryItem(
                                Icons.calendar_today,
                                '${widget.tripDetails['endDate'].difference(widget.tripDetails['startDate']).inDays + 1} Days',
                              ),
                              const SizedBox(width: 12),
                              _buildSummaryItem(
                                Icons.account_balance_wallet,
                                widget.tripDetails['budgetType'],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        'Introduction',
                        tripPlan['introduction'],
                        Icons.info_outline,
                      ),
                      const SizedBox(height: 24),
                      _buildDailyItinerary(tripPlan['dailyItinerary']),
                      const SizedBox(height: 24),
                      _buildRestaurants(tripPlan['restaurants']),
                      const SizedBox(height: 24),
                      _buildAttractions(tripPlan['attractions']),
                      const SizedBox(height: 24),
                      _buildTips(tripPlan['tips']),
                      const SizedBox(height: 24),
                      _buildExpenses(tripPlan['expenses']),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _launchFlightBooking,
        icon: const Icon(Icons.flight),
        label: const Text('Book Flights'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String text) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String text, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyItinerary(List<dynamic> itinerary) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(width: 8),
                Text(
                  'Daily Itinerary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...itinerary.map((day) => _buildDayCard(day)),
          ],
        ),
      ),
    );
  }

  Future<List<String>> _getPlacePhotos() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/textsearch/json'
          '?query=${widget.tripDetails['description']}+tourist+attractions'
          '&key=AIzaSyDbYXSuAOqiCl6RIqgSwdyvLQFy8qg25ws'
        ),
      );

      final result = json.decode(response.body);
      List<String> photoUrls = [];

      if (result['status'] == 'OK') {
        for (var place in result['results'].take(5)) {
          if (place['photos'] != null) {
            final photoReference = place['photos'][0]['photo_reference'];
            final photoUrl = 'https://maps.googleapis.com/maps/api/place/photo'
                '?maxwidth=800'
                '&photo_reference=$photoReference'
                '&key=AIzaSyDbYXSuAOqiCl6RIqgSwdyvLQFy8qg25ws';
            photoUrls.add(photoUrl);
          }
        }
      }
      return photoUrls;
    } catch (e) {
      return [];
    }
  }

  Widget _buildDefaultHeader(Map<String, dynamic> day) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 40,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 8),
            Text(
              'Day ${day['day']}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchFlightBooking() async {
    final destination = widget.tripDetails['description'];
    final startDate = DateFormat('yyyy-MM-dd').format(widget.tripDetails['startDate']);
    final endDate = DateFormat('yyyy-MM-dd').format(widget.tripDetails['endDate']);
    
    final city = destination.split(',')[0].trim();
    
    final flightWebsites = [
      {
        'name': 'MakeMyTrip',
        'url': 'https://www.makemytrip.com/flights/',
        'icon': 'https://imgak.mmtcdn.com/pwa_v3/pwa_hotel_assets/header/mmtlogo.png',
      },
      {
        'name': 'Goibibo',
        'url': 'https://www.goibibo.com/flights/',
        'icon': 'https://www.goibibo.com/favicon.ico',
      },
      {
        'name': 'EaseMyTrip',
        'url': 'https://www.easemytrip.com/flights.html',
        'icon': 'https://www.easemytrip.com/favicon.ico',
      },
      {
        'name': 'Booking.com',
        'url': 'https://www.booking.com/flights/',
        'icon': 'https://www.booking.com/favicon.ico',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.flight_takeoff, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Text(
                  'Book Flights',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Mumbai → $city',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '$startDate - $endDate',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...flightWebsites.map((site) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  final urlString = site['url'] as String;
                  try {
                    final Uri url = Uri.parse(urlString);
                    if (!await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    )) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not launch website'),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                        ),
                      );
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          site['icon'] as String,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.flight),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              site['name'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Search best flight deals',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            )),
            const SizedBox(height: 8),
            Text(
              'You will be redirected to the official website',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add other helper methods for building different sections...
} 
import 'package:flutter/material.dart';
import 'package:ai_travel_planner/screens/create_trip/trip_plan_screen.dart';

class TripLoadingScreen extends StatefulWidget {
  final Map<String, dynamic> tripDetails;

  const TripLoadingScreen({
    super.key,
    required this.tripDetails,
  });

  @override
  State<TripLoadingScreen> createState() => _TripLoadingScreenState();
}

class _TripLoadingScreenState extends State<TripLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<IconData> _travelIcons = [
    Icons.flight_takeoff,
    Icons.hotel,
    Icons.restaurant,
    Icons.local_activity,
    Icons.photo_camera,
    Icons.directions_car,
  ];
  int _currentIconIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Change icon every 2 seconds
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return false;
      setState(() {
        _currentIconIndex = (_currentIconIndex + 1) % _travelIcons.length;
      });
      return true;
    });

    // Simulate API call and navigate after delay
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TripPlanScreen(
              tripDetails: widget.tripDetails,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  RotationTransition(
                    turns: _controller,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Icon(
                      _travelIcons[_currentIconIndex],
                      key: ValueKey(_currentIconIndex),
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                'Creating Your Perfect Trip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const Text(
                  'Please wait while our AI crafts a personalized itinerary just for you...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _buildLoadingStep('Analyzing destination details', true),
              _buildLoadingStep('Considering your preferences', true),
              _buildLoadingStep('Crafting perfect itinerary', false),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  '${widget.tripDetails['description']}\n'
                  '${widget.tripDetails['travelType']} Trip • ${widget.tripDetails['budgetType']}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingStep(String text, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white70),
              color: completed ? Colors.white : Colors.transparent,
            ),
            child: completed
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.blue,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: completed ? Colors.white : Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
} 
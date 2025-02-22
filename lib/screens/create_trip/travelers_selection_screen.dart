import 'package:flutter/material.dart';

class TravelersSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> placeDetails;

  const TravelersSelectionScreen({
    super.key,
    required this.placeDetails,
  });

  @override
  State<TravelersSelectionScreen> createState() => _TravelersSelectionScreenState();
}

class _TravelersSelectionScreenState extends State<TravelersSelectionScreen> {
  String? selectedType;

  final List<Map<String, dynamic>> travelTypes = [
    {
      'type': 'Solo',
      'icon': Icons.person,
      'description': 'Just me',
      'color': Colors.blue,
      'gradient': [Colors.blue.shade300, Colors.blue.shade600],
      'illustration': Icons.hiking,
    },
    {
      'type': 'Couple',
      'icon': Icons.favorite,
      'description': 'Romantic getaway',
      'color': Colors.pink,
      'gradient': [Colors.pink.shade300, Colors.pink.shade600],
      'illustration': Icons.favorite_border,
    },
    {
      'type': 'Family',
      'icon': Icons.family_restroom,
      'description': 'Family vacation',
      'color': Colors.green,
      'gradient': [Colors.green.shade300, Colors.green.shade600],
      'illustration': Icons.child_care,
    },
    {
      'type': 'Friends',
      'icon': Icons.groups,
      'description': 'Trip with friends',
      'color': Colors.orange,
      'gradient': [Colors.orange.shade300, Colors.orange.shade600],
      'illustration': Icons.celebration,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'Who\'s Travelling?',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade700,
                          Colors.blue.shade900,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.2,
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                              ),
                              itemCount: 35,
                              itemBuilder: (context, index) {
                                final icons = [
                                  Icons.flight,
                                  Icons.beach_access,
                                  Icons.landscape,
                                  Icons.restaurant,
                                  Icons.local_hotel,
                                  Icons.camera_alt,
                                  Icons.directions_car,
                                ];
                                return Icon(
                                  icons[index % icons.length],
                                  color: Colors.white,
                                  size: 20,
                                );
                              },
                            ),
                          ),
                        ),
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
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.red),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Destination',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      widget.placeDetails['description'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Select your travel group',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final type = travelTypes[index];
                      final isSelected = selectedType == type['type'];
                      return Hero(
                        tag: 'travel_type_${type['type']}',
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedType = type['type'];
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: type['gradient'],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: type['color'].withOpacity(0.3),
                                    blurRadius: isSelected ? 12 : 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                border: isSelected
                                    ? Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      )
                                    : null,
                              ),
                              child: Stack(
                                children: [
                                  if (isSelected)
                                    Positioned(
                                      right: 8,
                                      top: 8,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 16,
                                          color: type['color'],
                                        ),
                                      ),
                                    ),
                                  Positioned(
                                    right: -20,
                                    bottom: -20,
                                    child: Icon(
                                      type['illustration'],
                                      size: 100,
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          type['icon'],
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                        const Spacer(),
                                        Text(
                                          type['type'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          type['description'],
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: travelTypes.length,
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: selectedType != null ? 1.0 : 0.0,
              child: ElevatedButton(
                onPressed: selectedType != null
                    ? () {
                        Navigator.pop(context, {
                          ...widget.placeDetails,
                          'travelType': selectedType,
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
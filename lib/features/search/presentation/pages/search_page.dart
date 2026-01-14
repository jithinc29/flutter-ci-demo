import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/search_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedTab = 0;
  String _selectedPriceType = 'Money';

  // Search parameters
  final TextEditingController _destinationController = TextEditingController(text: 'Miami, FL, United States');
  late String _checkinDateStr;
  late String _checkoutDateStr;
  DateTime get _checkinDate => DateTime.parse(_checkinDateStr);
  DateTime get _checkoutDate => DateTime.parse(_checkoutDateStr);
  int _adultsNumber = 1;
  int _roomNumber = 1;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _checkinDateStr = now.add(const Duration(days: 1)).toIso8601String().split('T').first;
    _checkoutDateStr = now.add(const Duration(days: 2)).toIso8601String().split('T').first;
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  String get _formattedDates {
    final checkin = '${_checkinDate.day.toString().padLeft(2, '0')} ${_checkinDate.month.toString().padLeft(2, '0')}';
    final checkout = '${_checkoutDate.day.toString().padLeft(2, '0')} ${_checkoutDate.month.toString().padLeft(2, '0')}';
    return '$checkin – $checkout';
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _checkinDate, end: _checkoutDate),
    );
    if (picked != null) {
      setState(() {
        _checkinDateStr = picked.start.toIso8601String().split('T').first;
        _checkoutDateStr = picked.end.toIso8601String().split('T').first;
      });
    }
  }

  void _selectRoomsAndGuests(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rooms & Guests'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text('Rooms: '),
                DropdownButton<int>(
                  value: _roomNumber,
                  items: List.generate(5, (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}'))),
                  onChanged: (value) => setState(() => _roomNumber = value!),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Adults: '),
                DropdownButton<int>(
                  value: _adultsNumber,
                  items: List.generate(10, (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}'))),
                  onChanged: (value) => setState(() => _adultsNumber = value!),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Text(
                'Find a Hotel',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),

            // Tabs
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  _buildTab('New Search', 0),
                  _buildTab('Recent Searches', 1),
                  _buildTab('Wishlists', 2),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Destination
                      _buildSearchItem(
                        icon: Icons.location_on,
                        iconColor: const Color(0xFFE85D3A),
                        label: 'Destination',
                        child: TextField(
                          controller: _destinationController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter destination',
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Divider(height: 1),

                      // Dates
                      _buildSearchItem(
                        icon: Icons.calendar_today,
                        iconColor: const Color(0xFFE85D3A),
                        label: 'Dates',
                        sublabel: 'Flexible',
                        value: _formattedDates,
                        onTap: () => _selectDateRange(context),
                      ),
                      const Divider(height: 1),

                      // Rooms & Guests
                      _buildSearchItem(
                        icon: Icons.person,
                        iconColor: const Color(0xFFE85D3A),
                        label: 'Rooms & Guests',
                        value: '$_roomNumber room, $_adultsNumber guest',
                        onTap: () => _selectRoomsAndGuests(context),
                      ),
                      const Divider(height: 1),

                      // Special Rates
                      _buildSearchItem(
                        icon: Icons.local_offer,
                        iconColor: const Color(0xFFE85D3A),
                        label: 'Special Rates',
                        value: 'Best Available',
                      ),
                      const Divider(height: 1),

                      const SizedBox(height: 30),

                      // Show price in
                      const Text(
                        'Show price in',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Price options
                      Row(
                        children: [
                          Expanded(child: _buildPriceOption('Money')),
                          Expanded(child: _buildPriceOption('Points')),
                          Expanded(child: _buildPriceOption('Points + Cash')),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Search button
                      Consumer(
                        builder: (context, ref, child) {
                          return SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                ref.read(searchHotelsProvider.notifier).searchHotels(
                                  destination: _destinationController.text,
                                  checkinDate: _checkinDateStr,
                                  checkoutDate: _checkoutDateStr,
                                  adultsNumber: _adultsNumber,
                                  roomNumber: _roomNumber,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE85D3A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Search hotels',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // IHG Army Hotels link
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Looking for IHG Army Hotels?',
                            style: TextStyle(
                              color: Color(0xFFE85D3A),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),

                      // Search Results
                      Consumer(
                        builder: (context, ref, child) {
                          final searchState = ref.watch(searchHotelsProvider);
                          return searchState.when(
                            data: (hotels) {
                              if (hotels.isEmpty) return const SizedBox();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 30),
                                  const Text(
                                    'Search Results',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ...hotels.map((hotel) => _buildHotelCard(hotel)),
                                ],
                              );
                            },
                            loading: () => const Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            error: (error, stack) => Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Center(
                                child: Text('Error: $error'),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch() {
    // For now, use hardcoded values. In a real app, parse from UI.
    // You can add text fields or date pickers to update _destination, etc.
    final ref = context as WidgetRef; // Wait, no, use Consumer or ref from build.
    // Actually, since it's Stateful, use ref from Consumer.
    // But to simplify, assume we have ref.
    // For now, call with current values.
    // But since no ref here, move to Consumer.
    // Wait, better to wrap the button in Consumer.
  }

  Widget _buildHotelCard(dynamic hotel) {
    print('Hotel object: $hotel'); // Debug
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Hotel image placeholder
            Container(
              width: 80,
              height: 80,
              color: Colors.grey.shade200,
              child: const Icon(Icons.hotel),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel['accessibilityLabel'] ?? hotel['name'] ?? hotel['hotel_name'] ?? 'Hotel Name',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hotel['address'] ?? hotel['hotel_address'] ?? 'Address',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${hotel['price'] ?? hotel['min_total_price'] ?? hotel['lowest_price'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE85D3A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? const Color(0xFFE85D3A)
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    String? sublabel,
    String? value,
    Widget? child,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 20, color: iconColor),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (sublabel != null) ...[
                        const Text(
                          ' • ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFE85D3A),
                          ),
                        ),
                        Text(
                          sublabel,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFE85D3A),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  child ?? Text(
                    value ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceOption(String title) {
    final isSelected = _selectedPriceType == title;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPriceType = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFF1F3A5F) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: title == 'Money'
              ? const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                )
              : title == 'Points + Cash'
              ? const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                )
              : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? const Color(0xFF1F3A5F) : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}

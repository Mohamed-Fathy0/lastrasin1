import 'package:flutter/material.dart';
import 'package:lastrasin1/view/screens/rent_recruit_screen.dart';

class PackegsRent extends StatelessWidget {
  const PackegsRent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('باقات متنوعة'),
        backgroundColor: const Color(0xFF004D40), // Adjust the color as needed
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildRentalCard(context, 'باقات بالساعات', 'خدمة بالساعات'),
            const SizedBox(height: 16), // Space between cards
            _buildRentalCard(context, 'باقات أسبوعية', 'خدمة بالاسبوع'),
            const SizedBox(height: 16), // Space between cards
            _buildRentalCard(context, 'باقات شهرية', 'خدمة بالشهر'),
          ],
        ),
      ),
    );
  }

  Widget _buildRentalCard(
      BuildContext context, String title, String description) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const RentRecruitScreen(title: "خدمات الباقة"),
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          gradient: LinearGradient(
            colors: [
              Colors.brown.shade500,
              Colors.brown.shade900,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

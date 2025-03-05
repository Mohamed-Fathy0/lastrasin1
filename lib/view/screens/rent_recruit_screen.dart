import 'package:flutter/material.dart';
import 'package:lastrasin1/view/screens/countries_screen.dart';
import 'package:lastrasin1/view/screens/form_order_screen.dart';

class RentRecruitScreen extends StatelessWidget {
  final String title;
  final String backgroundImagePath =
      'assets/images/background.jpg'; // ضع مسار الصورة هنا

  const RentRecruitScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final bool isRent = title == "إيجار";

    // تعديل الألوان إلى درجات البني
    final services = [
      ServiceItem('مساعدة منزلية', 'assets/house-cleaning.png',
          const Color(0xFF8B4513)), // بني داكن
      ServiceItem(
          'قيادة', 'assets/moving.png', const Color(0xFFA0522D)), // بني محروق
      // ServiceItem('عاملات نقل فوري', 'assets/driver-license.png',
      //     const Color(0xFFCD853F)), // بني فاتح
      // ServiceItem(
      //     'تمريض منزلي', 'assets/nurse.png', const Color(0xFFDEB887)), // بيج
      // ServiceItem(
      //     'طبخ', 'assets/cook.png', const Color(0xFFBC8F8F)), // بني وردي
      // ServiceItem(
      //     'مناسبات', 'assets/event.png', const Color(0xFFD2B48C)), // بني شاحب
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // خلفية الصورة
          Positioned.fill(
            child: Image.asset(
              backgroundImagePath,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'اختر نوع الخدمة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown[700], // لون النص بني
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return _buildServiceCard(
                      serviceT: services[index].title,
                      context: context,
                      service: services[index],
                      isRent: isRent,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required ServiceItem service,
    required String serviceT,
    required bool isRent,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderFormScreen(
            type: serviceT,
          ),
        ),
      ),

      // onTap: () => Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => CountryScreen(
      //       type: serviceT,
      //     ),
      //   ),
      // ),

      child: Container(
        decoration: BoxDecoration(
          color: service.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: service.color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: service.color.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                service.imagePath,
                height: 60,
                width: 60,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              service.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceItem {
  final String title;
  final String imagePath;
  final Color color;

  ServiceItem(this.title, this.imagePath, this.color);
}

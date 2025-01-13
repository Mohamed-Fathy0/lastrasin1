import 'package:flutter/material.dart';
import 'package:lastrasin1/model/s_model.dart';
import 'package:lastrasin1/view/widgets/scard.dart';

class HomeScreen extends StatelessWidget {
  // قائمة بالخدمات الاستاتيكية
  final List<Service> services = [
    Service(
      id: '1',
      name: 'تنظيف المنازل',
      description: 'خدمة تنظيف شاملة للمنازل بأسعار مناسبة وجودة عالية.',
      price: 150.0,
      imageUrl: 'assets/cleaning.png', // يمكنك تغييرها لمسار صورة حقيقي
    ),
    Service(
      id: '2',
      name: 'تصليح السباكة',
      description: 'إصلاح جميع أعطال السباكة بسرعة وكفاءة.',
      price: 200.0,
      imageUrl: 'assets/plumbing.png', // يمكنك تغييرها لمسار صورة حقيقي
    ),
    Service(
      id: '3',
      name: 'تصليح الكهرباء',
      description: 'حل جميع مشاكل الكهرباء المنزلية بواسطة فنيين متخصصين.',
      price: 250.0,
      imageUrl: 'assets/electrician.png', // يمكنك تغييرها لمسار صورة حقيقي
    ),
    Service(
      id: '4',
      name: 'تنسيق الحدائق',
      description: 'تصميم وتنسيق الحدائق المنزلية بأحدث الأساليب.',
      price: 300.0,
      imageUrl: 'assets/gardening.png', // يمكنك تغييرها لمسار صورة حقيقي
    ),
    Service(
      id: '5',
      name: 'نقل الأثاث',
      description: 'خدمة نقل الأثاث بأمان وسرعة مع فريق محترف.',
      price: 400.0,
      imageUrl: 'assets/moving.png', // يمكنك تغييرها لمسار صورة حقيقي
    ),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text(
          'خدمات رصين',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'أشهر الخدمات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  return ServiceCard(
                    service: services[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

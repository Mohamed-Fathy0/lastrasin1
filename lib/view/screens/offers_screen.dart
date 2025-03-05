import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lastrasin1/view/widgets/my_drawer.dart';
import 'package:lastrasin1/viewmodel/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:lastrasin1/viewmodel/worker_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
          ],
          title: const Text("العروض"),
          backgroundColor: Theme.of(context).primaryColor, // تحسين لون التطبيق
        ),
        body: const OffersList(),
      ),
    );
  }
}

class OffersList extends StatefulWidget {
  const OffersList({super.key});

  @override
  _OffersListState createState() => _OffersListState();
}

class _OffersListState extends State<OffersList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('offers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          // حالة عدم وجود عروض
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/no_offers.png",
                  height: 140,
                ),
                const SizedBox(height: 16),
                const Text(
                  'لا توجد عروض حاليا',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final offers = snapshot.data!.docs;

        return ListView.builder(
          itemCount: offers.length,
          itemBuilder: (context, index) {
            final offer = offers[index];
            final content = offer['contain'] ?? 'لا يوجد محتوى لهذا العرض';

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0), // حواف مستديرة
              ),
              elevation: 4, // إضافة ظل للكارد
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    content,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                leading: TextButton(
                  onPressed: () => _showWorkerSelectionDialog(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(12.0),
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondary, // تحسين لون الزر
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "تواصل مع خدمة العملاء \nواطلب العرض",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

void _showWorkerSelectionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: const Color.fromARGB(255, 83, 95, 140),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'خدمة العملاء',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                child: Consumer<WorkersProvider>(
                  builder: (context, workersProvider, child) {
                    return workersProvider.workers.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFFD700)),
                            ),
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: workersProvider.workers.length,
                            separatorBuilder: (context, index) => const Divider(
                              height: 1,
                              color: Colors.white24,
                            ),
                            itemBuilder: (context, index) {
                              final worker = workersProvider.workers[index];
                              return ListTile(
                                leading: SvgPicture.asset(
                                  "assets/whatsapp-svgrepo-com.svg",
                                  color: Colors.greenAccent,
                                ),
                                title: Text(
                                  worker.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  worker.phoneNumber,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Color(0xFFFFD700),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  openWhatsApp(context, worker.phoneNumber);
                                },
                              );
                            },
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void openWhatsApp(BuildContext context, String phoneNumber) async {
  final whatsappUrl = 'https://wa.me/$phoneNumber';

  if (await canLaunch(whatsappUrl)) {
    await launch(whatsappUrl);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تعذر فتح الواتساب')),
    );
  }
}

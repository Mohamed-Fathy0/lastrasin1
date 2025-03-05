import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:lastrasin1/viewmodel/worker_provider.dart';
import 'package:url_launcher/url_launcher.dart';

void showCountryList(BuildContext context, bool isRent, bool isOther,
    String selectedCountry, String service, bodyProvider) {
  if (!context.mounted) return; // التحقق من الصلاحية قبل متابعة التنفيذ

  print(bodyProvider.bodyValue);
  if (isRent && !isOther) {
    _showDurationBottomSheet(
        context, selectedCountry, service, isRent, bodyProvider);
  } else if (isOther || (isOther && !isRent) || (isOther && isRent)) {
    bodyProvider.bodyValue
        ? _showWorkerSelectionDialog(
            context, selectedCountry, service, isRent, 0, true)
        : _submitForm(service, selectedCountry, selectedCountry,
            selectedCountry, context, isRent);
  } else {
    _showRecruitmentForm(
        context, selectedCountry, service, isRent, bodyProvider);
  }
}

void _showDurationBottomSheet(BuildContext context, String selectedCountry,
    String service, bool isRent, bodyProvider) {
  if (!context.mounted) return; // التأكد من صلاحية الـ context

  int selectedDuration = 1; // Default is 1 month or year

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isRent ? 'اختر مدة التأجير'.tr() : 'اختر مدة ال'.tr(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                DropdownButton<int>(
                  value: selectedDuration,
                  items: List.generate(
                    isRent ? 12 : 10,
                    (index) {
                      final duration = index + 1;
                      return DropdownMenuItem<int>(
                        value: duration,
                        child: Text(isRent
                            ? '$duration ${'شهر'.tr()}'
                            : '$duration ${'عام'.tr()}'),
                      );
                    },
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedDuration = value;
                      });
                    }
                  },
                ),
                if (isRent)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (context.mounted) {
                        bodyProvider.bodyValue
                            ? _showWorkerSelectionDialog(
                                context,
                                selectedCountry,
                                service,
                                isRent,
                                selectedDuration,
                                false)
                            : _submitForm(
                                service,
                                selectedCountry,
                                selectedCountry,
                                selectedCountry,
                                context,
                                isRent);
                      }
                    },
                    child: Text('تأكيد'.tr()),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}

void _showRecruitmentForm(BuildContext context, String selectedCountry,
    String service, bool isRent, bodyProvider) {
  if (!context.mounted) return; // التحقق من الصلاحية

  int selectedYears = 1;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('اختر التفاصيل'.tr()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<int>(
                  value: selectedYears,
                  items: List.generate(10, (index) {
                    final year = index + 1;
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text('$year ${'سنة'.tr()}'),
                    );
                  }),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedYears = value;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('إلغاء'.tr()),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (context.mounted) {
                    bodyProvider.bodyValue
                        ? _showWorkerSelectionDialog(context, selectedCountry,
                            service, isRent, selectedYears, false)
                        : _submitForm(service, selectedCountry, selectedCountry,
                            selectedCountry, context, isRent);
                  }
                },
                child: Text('تأكيد'.tr()),
              ),
            ],
          );
        },
      );
    },
  );
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
void _submitForm(String jobTitle, String country, String secondChoice,
    String thirdChoice, BuildContext context, bool isRent) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final orderData = {
    'email': user.email,
    'firstName': user.displayName?.split(' ') ?? '',
    'lastName': user.displayName?.split(' ').last ?? '',
    'orderType': isRent ? 'طلب تأجير : $jobTitle' : 'طلب  : $jobTitle',
    'country': country,
    'secondChoice':
        jobTitle == 'سائق' ? 'العمر: $secondChoice' : 'الديانة: $secondChoice',
    'thirdChoice':
        jobTitle == 'سائق' ? 'الديانة: $thirdChoice' : 'الخبرة: $thirdChoice',
    'timestamp': FieldValue.serverTimestamp(),
    'orderStatus': "تم الاستلام",
  };

  try {
    await FirebaseFirestore.instance.collection('custom_orders').add(orderData);
    scaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text('تم إرسال الطلب بنجاح.'),
        backgroundColor: Colors.green,
      ),
    );
    // إذا كان الـ context mounted بنجاح، عرض الديالوج
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 40,
                ),
                SizedBox(width: 10),
                Text(
                  'نجاح',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: const Text(
              'تم إرسال الطلب بنجاح.',
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // إغلاق الديالوج
                },
                child: const Text(
                  'موافق',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('خطأ'),
            content: Text('فشل في إرسال الطلب: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إغلاق'),
              ),
            ],
          );
        },
      );
    }
  }
}

void _showWorkerSelectionDialog(BuildContext context, String selectedCountry,
    String service, bool isRent, int selectedYears, bool isOther) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: const Color(0xFF3F51B5),
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
                                  context.locale.languageCode == 'ar'
                                      ? worker.name
                                      : worker.nameEn,
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
                                  color: Colors.white,
                                ),
                                onTap: () async {
                                  final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: worker.phoneNumber,
                                  );
                                  if (await canLaunchUrl(launchUri)) {
                                    await launchUrl(launchUri);
                                  } else {
                                    throw 'Could not launch $launchUri';
                                  }
                                },
                              );
                            },
                          );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (isOther) {
                          _submitForm(service, selectedCountry, selectedCountry,
                              selectedCountry, context, isRent);
                        } else {
                          // Handle worker selection logic here
                        }
                      },
                      child: const Text('تأكيد'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

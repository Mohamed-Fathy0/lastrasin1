import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final TextEditingController _complaintController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Text(
                'من نحن؟',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF666666),
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                "مرحبًا بكم في شركة رصين  للخدمات رائدة في مجال توفير الخدمات  الموثوقة والمتميزة في المملكة العربية السعودية.نلتزم بجعل الخدمات أسهل وأكثر أمانًا لعملائنا، مع التركيز على جودة الخدمة ورضا العميل.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 40),

              // Grid section for features with icons
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildFeatureItem(
                    context,
                    icon: Icons.star,
                    label: 'خبرة واسعة',
                  ),
                  _buildFeatureItem(
                    context,
                    icon: Icons.security,
                    label: 'جودة مضمونة',
                  ),
                  _buildFeatureItem(
                    context,
                    icon: Icons.public,
                    label: 'خدمة عالمية',
                  ),
                  _buildFeatureItem(
                    context,
                    icon: Icons.headset_mic,
                    label: 'دعم فوري',
                  ),
                  // _buildFeatureItem(
                  //   context,
                  //   icon: Icons.group,
                  //   label: 'عمالة مختارة',
                  // ),
                  // _buildFeatureItem(
                  //   context,
                  //   icon: Icons.timer,
                  //   label: ' سريع',
                  // ),
                  _buildFeatureItem(
                    context,
                    icon: Icons.lock,
                    label: 'أمان وثقة',
                  ),
                  _buildFeatureItem(
                    context,
                    icon: Icons.lightbulb,
                    label: 'ابتكار مستمر',
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Complaint form section
              Text(
                'الشكوى',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _complaintController,
                decoration: InputDecoration(
                  hintText: 'اكتب شكواك هنا...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
                minLines: 1,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendComplaint,
                child: Text('إرسال الشكوى'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context,
      {required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF004D40), size: 35),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendComplaint() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final complaintText = _complaintController.text;
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'info@lastrasin1alkhalej.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'complaint_subject'.tr(),
        'body': complaintText
      }),
    );
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('email_error'.tr())),
      );
    }
  }
}

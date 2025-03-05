import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تواصل معنا'),
        centerTitle: true,
        backgroundColor: const Color(0xFF004D40),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCompanyInfo(context),
            _buildWebsiteContact(),
            _buildSocialMedia(),
            //   _buildCustomerService(),
          ],
        ),
      ),
    );
  }

  Widget _buildWebsiteContact() {
    const String websiteLink = "https://lastrasin1alkhalej.com/";
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () => _launchUrl(websiteLink),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF004D40),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.web, color: Colors.white, size: 28),
              Text(
                "زر موقعنا الإلكتروني",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialMedia() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'التواصل الاجتماعي',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _SocialMediaRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerService() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'خدمة العملاء',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _CustomerServiceRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyInfo(BuildContext context) {
    return GestureDetector(
      onTap: () => _openLocation(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.location_on, size: 48, color: Color(0xFF004D40)),
              const SizedBox(height: 8),
              Text(
                'City'.tr(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLocation() async {
    const String locationUrl =
        'https://maps.app.goo.gl/4KS37j8GXogHpsBm8?g_st=com.google.maps.preview.copy';
    if (await canLaunch(locationUrl)) {
      await launch(locationUrl);
    } else {
      print('Could not launch $locationUrl');
    }
  }

  static void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}

class _SocialMediaRow extends StatelessWidget {
  const _SocialMediaRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialButton('assets/snapchat-svgrepo-com.svg',
            'https://snapchat.com/add/lastrasin1.alk', 60),
        _buildSocialButton('assets/icons8-tiktok.svg',
            'https://www.tiktok.com/@lastrasin1.alk', 48),
        _buildSocialButton('assets/instagram-1-svgrepo-com.svg',
            'https://www.instagram.com/lastrasin1.alk', 48),
      ],
    );
  }

  static Widget _buildSocialButton(
      String assetPath, String url, double height) {
    return InkWell(
      onTap: () => _launchUrl(url),
      child: SvgPicture.asset(
        assetPath,
        width: 48,
        height: height,
      ),
    );
  }

  static void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class _CustomerServiceRow extends StatelessWidget {
  const _CustomerServiceRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // تحديد حجم GridView
      height: 600, // تحديد ارتفاع مناسب
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2, // تغيير عدد الأعمدة إذا لزم الأمر
        childAspectRatio: 1.0, // نسبة العرض إلى الارتفاع للتحكم في شكل العناصر
        children: [
          _buildContactItem('خدمة العملاء 1', '+9660575980275'),
          _buildContactItem('خدمة العملاء 2', '+9660592293300'),
          _buildContactItem('خدمة العملاء 3', '+9660537135293'),
          _buildContactItem('خدمة العملاء 4', '+9660533278070'),
          _buildContactItem('خدمة العملاء 5', '+9660503383120'),
          _buildContactItem('خدمة العملاء 6', '+9660507258594'),
          _buildContactItem('خدمة العملاء 7', '+9660533984642'),
          _buildContactItem('خدمة العملاء 8', '+9660550217866'),
        ],
      ),
    );
  }

  static Widget _buildContactItem(String name, String phone) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 40, color: Color(0xFF004D40)),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _launchWhatsApp(phone),
              child: const Text('اتصل بنا'),
            ),
          ],
        ),
      ),
    );
  }

  static void _launchWhatsApp(String phone) async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: phone,
    );
    if (await canLaunch(whatsappUri.toString())) {
      await launch(whatsappUri.toString());
    } else {
      print('Could not launch WhatsApp for $phone');
    }
  }
}

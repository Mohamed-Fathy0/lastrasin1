import 'package:easy_localization/easy_localization.dart';

// Define the services list function to return localized data
List<Map<String, dynamic>> getLocalizedServices() {
  return [
    {
      "category": "Home Cleaning".tr(),
      "services": [
        "Home Cleaning Services".tr(),
        "Ironing & laundry Service".tr()
      ]
    },
    {
      "category": "Home Maintenance".tr(),
      "services": ["Kitchen Service".tr(), "Bathroom service".tr()]
    },
    {
      "category": "Others".tr(),
      "services": ["Drivers".tr()]
    }
  ];
}

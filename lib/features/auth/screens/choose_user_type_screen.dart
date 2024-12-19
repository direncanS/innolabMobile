import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vienna_life_quality/common/widgets/custom_app_bar.dart';
import 'package:vienna_life_quality/features/auth/controllers/auth_controller.dart';
import 'package:vienna_life_quality/helper/route_helper.dart';
import 'package:vienna_life_quality/util/styles.dart';

import '../../../common/controllers/localization_controller.dart';
import '../../../common/models/language_model.dart';
import '../../../util/app_layout.dart';
import '../../../util/images.dart';

class ChooseUserTypeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'choose_user_type'.tr,
        isCenter: true,
        hasDivider: false,
        isBackButtonExist: false,
        bgColor: Colors.black,
        textColor: Colors.white,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'description_1'.tr,
                  style: poppinsRegular,
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Text(
                  'description_2'.tr,
                  style: poppinsRegular,
                  textAlign: TextAlign.center),
              const SizedBox(height: 30),
              Row(
                children: [
                  UserTypeContainer(
                    userType: 'parent',
                    userTypeIcon: Images.parentIcon,
                    userTypeText: 'parent'.tr,
                  ),
                  SizedBox(width: 16),
                  UserTypeContainer(
                    userType: 'student',
                    userTypeIcon: Images.studentIcon,
                    userTypeText: 'student'.tr,
                  ),
                  SizedBox(width: 16),
                  UserTypeContainer(
                    userType: 'retiree',
                    userTypeIcon: Images.retireeIcon,
                    userTypeText: 'retiree'.tr,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserTypeContainer extends StatelessWidget {
  final String userType;
  final String userTypeIcon;
  final String userTypeText;

  const UserTypeContainer({
    super.key, required this.userType, required this.userTypeIcon, required this.userTypeText,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Get.find<AuthController>().setUserType(userType);
              Get.toNamed(RouteHelper.getHomeRoute());
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(userTypeIcon),  // Değişkenle ikon belirlenir
                    width: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    userTypeText,  // Değişkenle metin belirlenir
                    style: poppinsMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
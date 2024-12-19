import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../util/app_layout.dart';
import '../../util/styles.dart';
import '../controllers/localization_controller.dart';
import '../models/language_model.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool fromQRCode;
  final String title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final bool showCart;
  final Color? bgColor;
  final Color? textColor;
  final List<Widget>? actionWidgets;
  final Function(String value)? onVegFilterTap;
  final String? type;
  final double? elevation;
  final bool isCenter;
  final bool hasDivider;
  const CustomAppBar({super.key, required this.title, this.isBackButtonExist = true, this.onBackPressed,
    this.showCart = false, this.bgColor, this.onVegFilterTap, this.type, this.fromQRCode = false, this.actionWidgets, this.textColor, this.elevation, this.isCenter = true, this.hasDivider = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: isCenter ? Text(title, style: poppinsRegular.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: textColor ?? Theme.of(context).textTheme.bodyLarge!.color)) : null,
          centerTitle: isCenter ? true : null,
          leadingWidth: isCenter ? 56 : 250,
          toolbarHeight: 70,
          leading: isBackButtonExist ? IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: bgColor == null ? Theme.of(context).textTheme.bodyLarge!.color : textColor ?? Theme.of(context).cardColor,
            onPressed: () => onBackPressed != null ? onBackPressed!() : Get.back(),
          ) : isCenter ? const SizedBox() : Center(child: Container(margin: EdgeInsets.only(left: 15), width: 250, color: Theme.of(context).cardColor, child: Text(title, textAlign: TextAlign.start, style: poppinsSemiBold.copyWith(fontSize: 22, color: const Color(0xFF323232)),))),
          backgroundColor: bgColor ?? Theme.of(context).cardColor,
          elevation: elevation ?? 0,
          surfaceTintColor: Theme.of(context).cardColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.language),
              color: Colors.white,
              onPressed: () => Get.bottomSheet(
                Container(
                  height: 400,
                  padding: EdgeInsets.all(32),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: GetBuilder<LocalizationController>(
                    builder: (localizationController) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'choose_language'.tr,
                                style: poppinsMedium.copyWith(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(
                                      context); // Bottom sheet kapatılır
                                },
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: localizationController.languages.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                LanguageModel language =
                                localizationController.languages[index];
                                return ListTile(
                                  leading: Radio<int>(
                                    value: index,
                                    groupValue:
                                    localizationController.selectedIndex,
                                    onChanged: (value) {
                                      localizationController
                                          .setSelectIndex(value!);
                                      localizationController.setLanguage(Locale(
                                          language.languageCode!,
                                          language.countryCode));
                                      Navigator.pop(context);
                                    },
                                  ),
                                  title: Text(language.languageName!, style: poppinsRegular.copyWith(fontSize: 14)),
                                  horizontalTitleGap: 0,
                                  contentPadding: EdgeInsets.zero,
                                  minVerticalPadding: 0,
                                  dense: true,
                                  onTap: () {
                                    localizationController.setSelectIndex(index);
                                    localizationController.setLanguage(Locale(
                                        language.languageCode!,
                                        language.countryCode));
                                    Navigator.pop(
                                        context); // Seçim yapıldıktan sonra bottom sheet kapanır
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ]
        ),
        hasDivider ? Divider(
          height: 1, // Çizginin yüksekliği.
          color: Theme.of(context).disabledColor.withOpacity(0.3), // Çizginin rengi.
          thickness: 1, // Çizginin kalınlığı.
        ) : const SizedBox.shrink(),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(71);
}

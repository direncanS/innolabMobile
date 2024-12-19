import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vienna_life_quality/features/splash/controllers/splash_controller.dart';
import '../../../util/app_layout.dart';
import '../../../util/images.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController splashController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(image: AssetImage(Images.viennaCountry), width: 300),
                  SvgPicture.asset(Images.logoText,
                      width: 300),
                  SizedBox(height: 30),
                  const CircularProgressIndicator(color: Color(0xFFDA121A),),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: SizedBox(
                width: double.infinity,
                height: 150,
                child: SvgPicture.asset(
                  Images.cityShape,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: 150,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

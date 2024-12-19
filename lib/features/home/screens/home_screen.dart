import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:vienna_life_quality/features/auth/controllers/auth_controller.dart';
import 'package:vienna_life_quality/features/home/controllers/quality_of_life_controller.dart';
import 'package:vienna_life_quality/util/app_layout.dart';
import 'package:vienna_life_quality/util/styles.dart';

import '../../../common/controllers/location_controller.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../util/app_constants.dart';
import '../../../util/images.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.find();
  final LocationController locationController = Get.find();
  final QualityOfLifeController qualityOfLifeController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      qualityOfLifeController.fetchQualityOfLifeData(
        latitude: locationController.currentPosition.value!.latitude.toString(),
        longitude: locationController.currentPosition.value!.longitude.toString(),
        userType: authController.userType.value,
        subDistrictName: locationController.subDistrictName.value,
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: 'qualityOfLifeTitle'.trParams({
          'userType': authController.getUserType(),
        }),
        isCenter: true,
        hasDivider: false,
        isBackButtonExist: true,
        bgColor: Colors.black,
        textColor: Colors.white,
        elevation: 10,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: SingleChildScrollView(
          child: GetBuilder<LocationController>(builder: (locationController) {
            return GetBuilder<QualityOfLifeController>(
                builder: (qualityOfLifeController) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    Autocomplete<String>(
                      optionsBuilder:
                          (TextEditingValue textEditingValue) async {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return await locationController
                            .getAutocompleteSuggestions(textEditingValue.text);
                      },
                      onSelected: (String selectedAddress) {
                        locationController
                            .updatePositionFromAddress(selectedAddress);
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController textController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted) {
                        textController.text =
                            locationController.currentAddress.value;
                        return TextField(
                          controller: textController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            labelText: 'update_your_address'.tr,
                            labelStyle: poppinsMedium.copyWith(
                                color: Colors.black, fontSize: 14),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            hintText: 'enter_an_address'.tr,
                            isDense: true,
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Theme.of(context).disabledColor,
                                )),
                            hintStyle: poppinsRegular.copyWith(
                                color: Theme.of(context).hintColor),
                            prefixIcon: Icon(Icons.map_outlined,
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.3),
                                size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear,
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.3),
                                  size: 20),
                              onPressed: () {
                                textController.clear();
                              },
                            ),
                          ),
                        );
                      },
                      optionsViewBuilder: (BuildContext context,
                          AutocompleteOnSelected<String> onSelected,
                          Iterable<String> options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4.0,
                            child: SizedBox(
                              height: 200.0,
                              child: ListView.builder(
                                padding: EdgeInsets.all(8.0),
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final String option =
                                      options.elementAt(index);
                                  return ListTile(
                                    title: Text(option),
                                    onTap: () => onSelected(option),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 40),
                    locationController.currentPosition.value == null
                        ? const CircularProgressIndicator(
                            color: Color(0xFFDA121A),
                          )
                        : locationController.isInVienna.value == false
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    googleMapContainerWidget(),
                                    const SizedBox(height: 10),
                                    Text(
                                      'you_are_outside_of_vienna'.tr,
                                      style: poppinsRegular.copyWith(
                                          fontSize: 16,
                                          color: const Color(0xFFDA121A)),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        locationController.initLocation();
                                      },
                                      child: Text('refresh_location'.tr,
                                          style: poppinsRegular.copyWith(
                                              fontSize: 14,
                                              color: Colors.black)),
                                    ),
                                  ],
                                ),
                              )
                            : Center(
                                child: Column(
                                  children: [
                                    googleMapContainerWidget(),
                                    const SizedBox(height: 20),
                                    Obx(() {
                                      if (qualityOfLifeController
                                          .isLoading.value) {
                                        return const CircularProgressIndicator();
                                      } else if (qualityOfLifeController
                                              .qualityOfLifeData.value !=
                                          null) {
                                        return calculationResultsBlock();
                                      } else {
                                        return Text('no_data'.tr);
                                      }
                                    }),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              )
                  ],
                ),
              );
            });
          }),
        ),
      ),
    );
  }

  Column calculationResultsBlock() {
    final QualityOfLifeController qualityOfLifeController = Get.find();

    return Column(
      children: [
        Obx(() {
          return Container(
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image(
                            image: authController.userType.value == 'student'
                                ? const AssetImage(Images.studentIcon)
                                : authController.userType.value == 'retiree'
                                    ? const AssetImage(Images.retireeIcon)
                                    : const AssetImage(Images.parentIcon),
                            width: 50,
                          ),
                          SizedBox(height: 5),
                          Text(
                            authController.userTypeText.value,
                            style: poppinsMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('quality_score_of_life'.tr,
                              style: poppinsMedium.copyWith(fontSize: 16)),
                          SizedBox(height: 10),
                          LinearPercentIndicator(
                            width: 280,
                            lineHeight: 25.0,
                            percent: qualityOfLifeController.qualityOfLifeData
                                .value!.qualityOfLifeScore /
                                100,
                            backgroundColor: Colors.grey.shade200,
                            animation: true,
                            progressColor: const Color(0xFFDA121A),
                            barRadius: const Radius.circular(10),
                            padding: EdgeInsets.zero,
                            center: Text(
                              '% ${qualityOfLifeController.qualityOfLifeData.value!.qualityOfLifeScore}',
                              style: poppinsMedium.copyWith(fontSize: 14, color: (qualityOfLifeController.qualityOfLifeData
                                  .value!.qualityOfLifeScore /
                                  100) < 0.6 ? Colors.black : Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  Text(
                    'quality_of_life_description_title'.tr,
                    style: poppinsBold.copyWith(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                      '${'quality_score_of_life'.tr}: ${qualityOfLifeController.qualityOfLifeData.value!.qualityOfLifeScore}'),
                  Text(
                      '${'recommendation'.tr}: ${qualityOfLifeController.recommendation(authController.userTypeText.value)}'),
                  Text(
                      '${'subdistrict'.tr}: ${qualityOfLifeController.qualityOfLifeData.value!.subdistrict.name}'),
                  Text(
                      '${'education_level'.tr}: ${qualityOfLifeController.qualityOfLifeData.value!.educationLevel}'),
                  Text(
                      '${'air_quality'.tr}: ${qualityOfLifeController.qualityOfLifeData.value!.airQuality}'),
                  Text(
                      '${'number_of_kindergartens'.tr}: ${qualityOfLifeController.qualityOfLifeData.value!.numberOfKindergartens}'),
                  Text(
                      '${'number_of_parks'.tr}: ${qualityOfLifeController.qualityOfLifeData.value!.numberOfParks}'),
                  Text(
                      '${'number_of_transit_stops'.tr}: ${qualityOfLifeController.qualityOfLifeData.value!.numberOfTransitStops}'),
                  Text(
                      '${'number_of_social_markets'.tr}: ${qualityOfLifeController.qualityOfLifeData.value!.numberOfSocialMarkets}'),
                  Text(
                      '${'number_of_libraries'.tr}: ${qualityOfLifeController.qualityOfLifeData.value!.numberOfLibraries}'),
                  Text(
                      '${'number_of_playgrounds'.tr}: ${qualityOfLifeController.qualityOfLifeData.value!.numberOfPlaygrounds}'),
                  Text(
                      '${'number_of_police_stations'.tr}: ${qualityOfLifeController.qualityOfLifeData.value!.numberOfPoliceStations}'),
                  /*qualityOfLifeController.qualityOfLifeData.value?.parks !=
                            null &&
                        qualityOfLifeController
                            .qualityOfLifeData.value!.parks.isNotEmpty
                    ? Column(
                        children: qualityOfLifeController
                            .qualityOfLifeData.value!.parks
                            .map((park) => Text(
                                'Park: ${park.name}, Distance: ${park.distance}'))
                            .toList(),
                      )
                    : const Text("No parks available"),
                // Park verisi yoksa gösterilecek metin
                SizedBox(height: 10),
                qualityOfLifeController.qualityOfLifeData.value?.transitStops !=
                            null &&
                        qualityOfLifeController
                            .qualityOfLifeData.value!.transitStops.isNotEmpty
                    ? Column(
                        children: qualityOfLifeController
                            .qualityOfLifeData.value!.transitStops
                            .map((stop) => Text(
                                'Transit Stop: ${stop.name}, Distance: ${stop.distance}'))
                            .toList(),
                      )
                    : const Text("No transit stops available"),*/
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Column googleMapContainerWidget() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 300,
            child: GoogleMap(
              onMapCreated: locationController.onMapCreated,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  locationController.currentPosition.value?.latitude ?? 0.0,
                  locationController.currentPosition.value?.longitude ?? 0.0,
                ),
                zoom: 14.0,
              ),
              markers: locationController.currentPosition.value != null
                  ? {
                      Marker(
                        markerId: MarkerId("currentLocation"),
                        position: LatLng(
                          locationController.currentPosition.value!.latitude,
                          locationController.currentPosition.value!.longitude,
                        ),
                        infoWindow: InfoWindow(
                            title: locationController.currentAddress.value),
                      ),
                    }
                  : {},
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'current_location'.tr,
          textAlign: TextAlign.center,
          style: poppinsMedium.copyWith(fontSize: 16),
        ),
        Text(
          locationController.currentAddress.value,
          textAlign: TextAlign.center,
          style: poppinsRegular.copyWith(fontSize: 14),
        ),
        Text(
          "(${locationController.currentPosition.value?.latitude.toString() ?? '0.0'}, "
          "${locationController.currentPosition.value?.longitude.toString() ?? '0.0'})",
          style: poppinsRegular.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}

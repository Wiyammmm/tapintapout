import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tapintapout/controllers/data_controller.dart';

import 'package:tapintapout/controllers/station_controller.dart';
import 'package:tapintapout/core/sweetalert.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/data/hive_service.dart';
import 'package:tapintapout/models/session_model.dart';
import 'package:tapintapout/models/station_model.dart';
import 'package:tapintapout/presentation/pages/homePage.dart';
import 'package:tapintapout/presentation/widgets/base.dart';

class SelectRoutePage extends StatelessWidget {
  final DataController dataController = Get.put(DataController());
  final StationController stationController = Get.put(StationController());
  // final dataController dataController = Get.put(dataController());
  HiveService hiveService = HiveService();
  ScrollController routeScrollController = ScrollController();
  ScrollController vehicleScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    // final DataController dataController = Get.put(DataController());
    //
    return RefreshIndicator(
      onRefresh: () async {
        await dataController.fetchAndStoreData();
        print('refresh');
        return;
      },
      child: BasePage(
        floatingButton: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  processServices.selectRouteVehicleProcess(context);
                },
                child: const Text(
                  'Proceed',
                  style: TextStyle(fontSize: 25),
                ))),
        child: Stack(
          children: [
            Obx(() {
              return Skeletonizer(
                enabled: dataController.isLoading.value,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Vehicle',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      GestureDetector(
                        onTap: () {
                          dataController.isVehicleVisible.value =
                              !dataController.isVehicleVisible.value;
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(dataController
                                            .selectedVehicle.value !=
                                        null
                                    ? '${dataController.selectedVehicle.value?.vehicle_no}:${dataController.selectedVehicle.value?.plate_no}'
                                    : 'Select a vehicle'),
                              ),
                              Icon(dataController.isVehicleVisible.value
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_right)
                            ],
                          ),
                        ),
                      ),
                      Offstage(
                        offstage: !dataController.isVehicleVisible.value,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Wrap(
                              children: [
                                SizedBox(
                                    height: 50,
                                    child: TextField(
                                      // controller: _searchController,
                                      decoration: const InputDecoration(
                                          hintText: 'Search',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 10)),
                                      onChanged: (query) =>
                                          dataController.filterRoutes(query),
                                    )),
                                Container(
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      minHeight: 0),
                                  child: Obx(() {
                                    return ScrollbarTheme(
                                      data: ScrollbarThemeData(
                                        thumbColor: MaterialStateProperty.all(Colors
                                            .blue), // Color of the scrollbar thumb
                                        trackColor: MaterialStateProperty.all(
                                            Colors.grey.withOpacity(
                                                0.3)), // Color of the track
                                        thickness: MaterialStateProperty.all(
                                            5.0), // Thickness of the scrollbar
                                        radius: const Radius.circular(
                                            10.0), // Rounded scrollbar corners
                                        thumbVisibility: MaterialStateProperty.all(
                                            true), // Always show the scrollbar
                                      ),
                                      child: Scrollbar(
                                        controller: vehicleScrollController,
                                        child: ListView.builder(
                                          controller: vehicleScrollController,
                                          itemCount: dataController
                                              .filteredVehicles.length,
                                          shrinkWrap:
                                              true, // Makes the ListView shrink to fit its content
                                          physics:
                                              ClampingScrollPhysics(), // Prevents unnecessary scrolling
                                          itemBuilder: (context, index) {
                                            final vehicle = dataController
                                                .filteredVehicles[index];
                                            bool isActive = dataController
                                                    .selectedVehicle.value ==
                                                vehicle;
                                            return ListTile(
                                              title: Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: isActive
                                                        ? Colors.blueAccent
                                                        : Colors.white,
                                                    border: Border.all(
                                                        width: 1.5,
                                                        color: isActive
                                                            ? Colors.white
                                                            : Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                    child: Text(
                                                  '${vehicle.vehicle_no}:${vehicle.plate_no}',
                                                  style: TextStyle(
                                                      color: isActive
                                                          ? Colors.white
                                                          : Colors.black),
                                                )),
                                              ),
                                              // subtitle: Text(
                                              //     'Fare: ${route.minimum_fare} - ${route.maximumFare}'),
                                              onTap: () async {
                                                dataController.selectedVehicle
                                                    .value = vehicle;
                                                dataController.isVehicleVisible
                                                    .value = false;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        'Select Route',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      GestureDetector(
                        onTap: () {
                          dataController.isRouteVisible.value =
                              !dataController.isRouteVisible.value;
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(dataController
                                            .selectedRoute.value !=
                                        null
                                    ? '${dataController.selectedRoute.value?.origin}-${dataController.selectedRoute.value?.destination}'
                                    : 'Select a route'),
                              ),
                              Icon(dataController.isRouteVisible.value
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_right)
                            ],
                          ),
                        ),
                      ),
                      Offstage(
                        offstage: !dataController.isRouteVisible.value,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Wrap(
                              children: [
                                SizedBox(
                                    height: 50,
                                    child: TextField(
                                      // controller: _searchController,
                                      decoration: const InputDecoration(
                                          hintText: 'Search',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 10)),
                                      onChanged: (query) =>
                                          dataController.filterRoutes(query),
                                    )),
                                Container(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.25,
                                  ),
                                  child: Stack(
                                    children: [
                                      Obx(() {
                                        print(
                                            "dataController.errorPrompt: ${dataController.errorPrompt}");
                                        if (dataController
                                            .errorPrompt.isNotEmpty) {
                                          print('errorPrompt not empty');
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            if (Navigator.of(Get.context!)
                                                .canPop()) {
                                              Navigator.of(Get.context!)
                                                  .pop(); // This will close the dialog if it's open
                                            } else {
                                              print(
                                                  "No active dialog to close.");
                                            }
                                            SweetAlertUtils.showErrorDialog(
                                                context,
                                                title: dataController
                                                    .errorPrompt.value['title'],
                                                thisTitle: dataController
                                                    .errorPrompt.value['label'],
                                                onConfirm: () {
                                              Navigator.of(context).pop();
                                              dataController
                                                  .fetchAndStoreData();
                                            });
                                          });
                                        }

                                        if (dataController
                                            .filteredRoutes.isEmpty) {
                                          return Center(
                                              child: Text('No routes found'));
                                        }

                                        return ScrollbarTheme(
                                          data: ScrollbarThemeData(
                                            thumbColor:
                                                MaterialStateProperty.all(Colors
                                                    .blue), // Color of the scrollbar thumb
                                            trackColor: MaterialStateProperty
                                                .all(Colors.grey.withOpacity(
                                                    0.3)), // Color of the track
                                            thickness: MaterialStateProperty.all(
                                                5.0), // Thickness of the scrollbar
                                            radius: const Radius.circular(
                                                10.0), // Rounded scrollbar corners
                                            thumbVisibility:
                                                MaterialStateProperty.all(
                                                    true), // Always show the scrollbar
                                          ),
                                          child: Scrollbar(
                                            controller: routeScrollController,
                                            child: ListView.builder(
                                              controller: routeScrollController,
                                              itemCount: dataController
                                                  .filteredRoutes.length,
                                              shrinkWrap:
                                                  true, // Makes the ListView shrink to fit its content
                                              physics:
                                                  ClampingScrollPhysics(), // Prevents unnecessary scrolling
                                              itemBuilder: (context, index) {
                                                final route = dataController
                                                    .filteredRoutes[index];
                                                bool isActive = dataController
                                                        .selectedRoute.value ==
                                                    route;
                                                return GestureDetector(
                                                  onTap: () {
                                                    dataController
                                                        .isRouteVisible
                                                        .value = false;
                                                    dataController
                                                        .isRouteVisible
                                                        .refresh();
                                                  },
                                                  child: ListTile(
                                                    title: Container(
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          color: isActive
                                                              ? Colors
                                                                  .blueAccent
                                                              : Colors.white,
                                                          border: Border.all(
                                                              width: 1.5,
                                                              color: isActive
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Center(
                                                          child: Text(
                                                        '${route.origin} to ${route.destination}',
                                                        style: TextStyle(
                                                            color: isActive
                                                                ? Colors.white
                                                                : Colors.black),
                                                      )),
                                                    ),
                                                    // subtitle: Text(
                                                    //     'Fare: ${route.minimum_fare} - ${route.maximumFare}'),
                                                    onTap: () async {
                                                      dataController
                                                          .selectedRoute
                                                          .value = route;
                                                      dataController
                                                          .isRouteVisible
                                                          .value = false;

                                                      // dataController.updateSession(route.id, );
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
            Align(
              alignment: Alignment.center,
              child: Obx(() {
                if (dataController.isLoading.value) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.5), // Shadow color with opacity
                          spreadRadius: 5, // How far the shadow spreads
                          blurRadius: 7, // How blurry the shadow is
                          offset:
                              Offset(0, 3), // Horizontal and vertical offset
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        direction: Axis.vertical,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text(
                              '${dataController.progressText.value}... ${(dataController.progress.value * 100).toStringAsFixed(0)}%'),
                        ],
                      ),
                    ),
                  );
                }
                return SizedBox();
              }),
            )
          ],
        ),
      ),
    );
  }
}

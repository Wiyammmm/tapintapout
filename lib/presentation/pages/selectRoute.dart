import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  @override
  Widget build(BuildContext context) {
    // final DataController dataController = Get.put(DataController());
    dataController.fetchAndStoreData();
    return RefreshIndicator(
      onRefresh: () async {
        await dataController.fetchAndStoreData();
        print('refresh');
      },
      child: BasePage(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Route',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                  height: 50,
                  child: TextField(
                    // controller: _searchController,
                    decoration: const InputDecoration(
                        hintText: 'Search',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
                    onChanged: (query) => dataController.filterRoutes(query),
                  )),
              Expanded(
                child: Obx(() {
                  print(
                      "dataController.errorPrompt: ${dataController.errorPrompt}");
                  if (dataController.errorPrompt.isNotEmpty) {
                    print('errorPrompt not empty');
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (Navigator.of(Get.context!).canPop()) {
                        Navigator.of(Get.context!)
                            .pop(); // This will close the dialog if it's open
                      } else {
                        print("No active dialog to close.");
                      }
                      SweetAlertUtils.showErrorDialog(context,
                          title: dataController.errorPrompt.value['title'],
                          thisTitle: dataController.errorPrompt.value['label'],
                          onConfirm: () {
                        Navigator.of(context).pop();
                        dataController.fetchAndStoreData();
                      });
                    });
                  }
                  if (dataController.isLoading.value) {
                    return Center(
                        child: Column(
                      children: [
                        CircularProgressIndicator(),
                        Text(
                            '${dataController.progressText.value}... ${(dataController.progress.value * 100).toStringAsFixed(0)}%'),
                      ],
                    ));
                  }
                  if (dataController.filteredRoutes.isEmpty) {
                    return Center(child: Text('No routes found'));
                  }

                  return ListView.builder(
                    itemCount: dataController.filteredRoutes.length,
                    itemBuilder: (context, index) {
                      final route = dataController.filteredRoutes[index];
                      return ListTile(
                        title: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(width: 1.5, color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                                  '${route.origin} to ${route.destination}')),
                        ),
                        // subtitle: Text(
                        //     'Fare: ${route.minimum_fare} - ${route.maximumFare}'),
                        onTap: () async {
                          List<StationModel> stations = await stationController
                              .fetchStationsByRouteId(route.id);
                          for (var station in stations) {
                            print('Station ID: ${station.id}');
                            print('Station Name: ${station.stationName}');
                            print('Station Number: ${station.stationNum}');
                            print('Latitude: ${station.lat}');
                            print('Longitude: ${station.long}');
                            print('---');
                          }
                          if (stations.isNotEmpty) {
                            print("stations.first.id: ${stations.first.id}");
                            routeController.getSelectedRoute(route.id);
                            dataController.updateSession(route.id,
                                stations.first.id, stations[1].id.toString());
                            SessionModel? session =
                                await hiveService.getSession();
                            print('Route ID: ${session?.routeId}');
                            print('Last Station ID: ${session?.lastStationId}');
                            print(
                                'startget Station ID: ${session?.targetStationId}');

                            Get.offAll(() => HomePage());
                          } else {
                            print('empty stations');
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                      child: FittedBox(
                                          child:
                                              Text('No Stations Registered'))),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Please assist to the admin')
                                    ],
                                  ),
                                );
                              },
                            );
                          }

                          // dataController.updateSession(route.id, );
                        },
                      );
                    },
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

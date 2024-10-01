import 'package:flutter/material.dart';
import 'package:tapintapout/core/sweetalert.dart';
import 'package:tapintapout/presentation/pages/homePage.dart';
import 'package:tapintapout/presentation/widgets/base.dart';

class SelectRoutePage2 extends StatefulWidget {
  const SelectRoutePage2({super.key});

  @override
  State<SelectRoutePage2> createState() => _SelectRoutePage2State();
}

class _SelectRoutePage2State extends State<SelectRoutePage2> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allItems = List.generate(100, (index) => 'Item $index');
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _allItems
          .where((item) => item.toLowerCase().contains(query))
          .toList();
    });
  }

  void _selectedRoute(String thisRoute) {
    SweetAlertUtils.showConfirmationDialog(context, onConfirm: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }, thisTitle: 'Route: ${thisRoute}');
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
        child: Padding(
      padding: EdgeInsets.all(16),
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
                controller: _searchController,
                decoration: const InputDecoration(
                    hintText: 'Search',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
              )),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: ListView.builder(
                itemCount: _filteredItems.length, // Number of items in the list
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _selectedRoute(_filteredItems[index]),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        height: 50,
                        // width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1.5, color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Route:'),
                              Text('Route# ${_filteredItems[index]} ')
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    ));
  }
}

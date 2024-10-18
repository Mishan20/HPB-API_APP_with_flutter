import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import '../components/custom_container.dart';
import '../models/covid_data_model.dart';
import '../models/pcr_model.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService service = ApiService();
  DateTime? selectedDate; // To store the selected date

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: FutureBuilder(
            future: service.getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                CovidDataModel data = snapshot.data!;
                List<PcrData> pcrDataList = data.pcrData!;

                // Filter the PCR data based on the selected date
                if (selectedDate != null) {
                  pcrDataList = pcrDataList.where((pcr) {
                    DateTime pcrDate = DateTime.parse(pcr.date!);
                    return pcrDate.day == selectedDate!.day &&
                        pcrDate.month == selectedDate!.month &&
                        pcrDate.year == selectedDate!.year;
                  }).toList();
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu, color: Colors.black),
                            onPressed: () {},
                          ),
                          Text(
                            "Covid 19",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search, color: Colors.black),
                            onPressed: () {
                              DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime(2020, 1, 1),
                                maxTime: DateTime.now(),
                                onConfirm: (date) {
                                  setState(() {
                                    selectedDate =
                                        date; // Set the selected date
                                  });
                                },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomContainer(
                            size: size,
                            title: 'Total Deaths',
                            color: Colors.red.shade700,
                            value: data.totalDeaths!,
                          ),
                          CustomContainer(
                            size: size,
                            title: 'Total Recovered',
                            color: Colors.green.shade700,
                            value: data.totalRecovered!,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomContainer(
                            size: size,
                            title: 'Active Cases',
                            color: Colors.blue.shade700,
                            value: data.activeCases!,
                          ),
                          CustomContainer(
                            size: size,
                            title: 'Total Cases',
                            color: Colors.amber.shade800,
                            value: data.totalCases!,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Daily PCR Test",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      const Divider(thickness: 2),
                      pcrDataList.isNotEmpty
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: pcrDataList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            pcrDataList[index].date.toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            pcrDataList[index].count.toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Text(
                              "No data available for the selected date",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                    ],
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}

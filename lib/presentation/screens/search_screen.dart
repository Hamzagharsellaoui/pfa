import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/ConfigureContract1.dart';
import '../../data/repositories/ConfigureContract2.dart';
import '../../logic/doctor_list/doctor_list_bloc.dart';
import '../widgets/card_widget.dart';
import '../widgets/input_field.dart';
import '../../logic/doctor_list/doctor_list_bloc.dart';

import 'booking_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // instantiate both here using .auto()
  final ConfigureContract contract = ConfigureContract.auto();
  final ConfigureTokenContract tokenContract = ConfigureTokenContract.auto();

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorListBloc>(
      create: (_) =>
      DoctorListBloc(contract: contract)..add(FetchDoctors()),
      child: Scaffold(
        appBar: AppBar(title: Text("Search Doctors")),
        body: Column(
          children: [
            // If you need the input field, you can add it here:
            // InputField(controller: _searchController, hint: "Search..."),

            Expanded(
              child: BlocBuilder<DoctorListBloc, DoctorListState>(
                builder: (context, state) {
                  if (state is DoctorListLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is DoctorListError) {
                    return Center(
                        child:
                        Text("Error loading doctors: ${state.error}"));
                  } else if (state is DoctorListLoaded) {
                    final query = _searchController.text.toLowerCase();
                    final filtered = state.doctors.where((doc) {
                      return doc.name.toLowerCase().contains(query);
                    }).toList();

                    if (filtered.isEmpty) {
                      return Center(child: Text("No doctors found."));
                    }

                    return ListView(
                      children: [
                        DoctorCard(
                          doctorName: "Dr. Tarek Frikha",
                          imageUrl: "assets/images/frikh-3379374-small.gif",
                          rating: 2,
                          distance: 100,
                          isVerified: true,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => BookingScreen()),
                            );
                          },
                        ),
                        DoctorCard(
                          doctorName: "Dr. Emily Carter",
                          imageUrl: "assets/images/Emily-Carter.jpeg",
                          rating: 4,
                          distance: 700,
                          isVerified: true,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => BookingScreen()),
                            );
                          },
                        ),

                      ],
                    );

                  }
                  // initial / fallback
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

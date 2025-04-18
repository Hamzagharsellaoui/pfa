import 'package:flutter/material.dart';

import '../widgets/input_field.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: const EdgeInsets.all(15.0),
      child: InputField(
        controller: searchController,
        hintText: "Search Doctor",
        obscureText: false,
        // Fix: Search field should not be obscured
        prefixIcon: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () {},
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.tune, color: Colors.grey),
          onPressed: () {},
        ), onChanged: (value) {  }, keyboardType: TextInputType.text,
      ),
    );
  }
}

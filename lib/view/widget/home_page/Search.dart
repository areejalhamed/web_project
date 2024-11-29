import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {

  final Function(String) onSearchChanged;
  final TextEditingController controller;

  const SearchPage({
    Key? key,
    required this.onSearchChanged,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onSearchChanged,
      decoration: InputDecoration(
        labelText: 'Search...',
        prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.scrim),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.scrim),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.scrim),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

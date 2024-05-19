import 'package:flutter/material.dart';
import 'package:onlinedoctorapp/Doctors/specialities.dart'; // Import specialities.dart

class SortFilterDoctorsDialog extends StatefulWidget {
  final List<Map<String, dynamic>> allDoctors;
  final void Function(String?, bool, List<String>, List<int>) onApply;

  const SortFilterDoctorsDialog({
    Key? key,
    required this.allDoctors,
    required this.onApply,
  }) : super(key: key);

  @override
  SortFilterDoctorsDialogState createState() => SortFilterDoctorsDialogState();
}

class SortFilterDoctorsDialogState extends State<SortFilterDoctorsDialog> {
  String? _sortBy;
  bool _isAscending = true;
  final List<String> _selectedSpecialties = [];
  final List<int> _selectedRatings = [];
  List<String> _allSpecialties = [];

  @override
  void initState() {
    super.initState();
    _sortBy = 'name'; // Initialize sortBy with default value
    _fetchSpecialties();
  }

  Future<void> _fetchSpecialties() async {
    try {
      List<String> specialities = await Specialities
          .fetchSpecialities(); // Fetch specialties from specialities.dart
      setState(() {
        _allSpecialties = specialities;
      });
    } catch (error) {
      print('Error fetching specialties: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sort and Filter'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSortDropdown(),
            const Divider(),
            _buildFilterTitle('Specialties'),
            _buildSpecialtiesCheckboxes(),
            const Divider(),
            _buildFilterTitle('Ratings'),
            _buildRatingsCheckboxes(),
            const Divider(),
            _buildOrderToggle(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Ensure onApply callback is not null
            widget.onApply(
                _sortBy, _isAscending, _selectedSpecialties, _selectedRatings);
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButtonFormField<String>(
      value: _sortBy,
      onChanged: (value) {
        setState(() {
          _sortBy = value;
        });
      },
      items: const [
        DropdownMenuItem(
          value: 'name',
          child: Text('Name'),
        ),
        DropdownMenuItem(
          value: 'specialty',
          child: Text('Specialty'),
        ),
        DropdownMenuItem(
          value: 'rating',
          child: Text('Rating'),
        ),
      ],
      decoration: const InputDecoration(
        labelText: 'Sort By',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildFilterTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSpecialtiesCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _allSpecialties.map((specialty) {
        return CheckboxListTile(
          title: Text(specialty),
          value: _selectedSpecialties.contains(specialty),
          onChanged: (value) {
            setState(() {
              if (value != null && value) {
                _selectedSpecialties.add(specialty);
              } else {
                _selectedSpecialties.remove(specialty);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildRatingsCheckboxes() {
    List<int> ratings = [1, 2, 3, 4, 5];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ratings.map((rating) {
        return CheckboxListTile(
          title: Text(rating.toString()),
          value: _selectedRatings.contains(rating),
          onChanged: (value) {
            setState(() {
              if (value != null && value) {
                _selectedRatings.add(rating);
              } else {
                _selectedRatings.remove(rating);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildOrderToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Ascending'),
        Switch(
          value: _isAscending,
          onChanged: (value) {
            setState(() {
              _isAscending = value;
            });
          },
        ),
        const Text('Descending'),
      ],
    );
  }
}

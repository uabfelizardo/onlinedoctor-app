import 'package:flutter/material.dart';
import 'package:onlinedoctorapp/Doctors/specialities.dart';
import 'package:onlinedoctorapp/ReusableElements/Buttons/custom_primary_button.dart';
import 'package:onlinedoctorapp/ReusableElements/Buttons/custom_secondary_button.dart';
import 'package:onlinedoctorapp/ReusableElements/Buttons/custom_sorting_order_button.dart';
import 'package:onlinedoctorapp/model/doctor.dart';

class SortFilterDoctorsDialog extends StatefulWidget {
  final List<Doctor> allDoctors;
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
      List<String> specialities = await Specialities.fetchSpecialities();
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
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
      title: const Text('Ordenar e Filtrar'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSortDropdown(),
            _buildOrderToggle(),
            const Divider(),
            _buildFilterTitle('Especialidades'),
            _buildSpecialtiesCheckboxes(),
            const Divider(),
            _buildFilterTitle('Ratings'),
            _buildRatingsCheckboxes(),
            const Divider(),
          ],
        ),
      ),
      actions: [
        SecondaryButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          label: 'Cancelar',
        ),
        PrimaryButton(
          onPressed: () {
            widget.onApply(
                _sortBy, _isAscending, _selectedSpecialties, _selectedRatings);
            Navigator.of(context).pop();
          },
          label: 'Aplicar',
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
          child: Text('Nome'),
        ),
        DropdownMenuItem(
          value: 'specialty',
          child: Text('Especialidade'),
        ),
        DropdownMenuItem(
          value: 'rating',
          child: Text('Rating'),
        ),
      ],
      decoration: const InputDecoration(
        labelText: 'Ordenar Por',
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
    return SortingOrderButton(
      isSelected: [_isAscending, !_isAscending],
      onPressed: (index) {
        setState(() {
          _isAscending = index == 0;
        });
      },
      children: const [
        Text('Ascendente'),
        Text('Descendente'),
      ],
    );
  }
}

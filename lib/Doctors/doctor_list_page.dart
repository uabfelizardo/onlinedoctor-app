import 'package:flutter/material.dart';
import 'package:onlinedoctorapp/AppBar/custom_app_bar.dart';
import 'package:onlinedoctorapp/Doctors/sort_filter_doctors_dialog.dart';

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({Key? key}) : super(key: key);

  @override
  DoctorListPageState createState() => DoctorListPageState();
}

class DoctorListPageState extends State<DoctorListPage> {
  List<Map<String, dynamic>> allDoctors = [
    {"name": "Ana Simões", "specialty": "Cardiologia", "rating": 3},
    {"name": "Bruno Rodrigues", "specialty": "Dermatologia", "rating": 4},
    {"name": "Catarina Marques", "specialty": "Neurologia", "rating": 5},
  ];

  List<Map<String, dynamic>> filteredDoctors = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDoctors = allDoctors;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredDoctors = allDoctors.where((doctor) {
        final name = doctor['name'].toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: ''),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Médicos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Pesquisar Médico(a)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person),
                      ),
                      title: Text(
                        filteredDoctors[index]['name'],
                        style: const TextStyle(fontSize: 20),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filteredDoctors[index]['specialty'],
                            style: const TextStyle(fontSize: 16),
                          ),
                          _buildRatingStars(filteredDoctors[index]['rating']),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Add navigation or action
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showSortFilterDialog();
        },
        icon: const Icon(Icons.filter_list),
        label: const Text('Sort & Filter'),
      ),
    );
  }

  Widget _buildRatingStars(int rating) {
    List<Widget> stars = [];
    for (int i = 0; i < rating; i++) {
      stars.add(const Icon(Icons.star, color: Colors.yellow));
    }
    return Row(children: stars);
  }

  void _showSortFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SortFilterDoctorsDialog(
          allDoctors: allDoctors,
          onApply: (sortBy, isAscending, selectedSpecialties, selectedRatings) {
            // Implement sort and filter functionality
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:onlinedoctorapp/Doctors/doctor_info_page.dart';
import 'package:onlinedoctorapp/Doctors/sort_filter_doctors_dialog.dart';
import 'package:onlinedoctorapp/base_page.dart';
import 'package:onlinedoctorapp/model/doctor.dart';

typedef PropertySelector<T> = Comparable Function(T);

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({Key? key}) : super(key: key);

  @override
  DoctorListPageState createState() => DoctorListPageState();
}

class DoctorListPageState extends State<DoctorListPage> {
  List<Doctor> allDoctors = [
    Doctor(
      id: 1,
      name: "Ana Simões",
      gender: "Female",
      birthdate: "1990-01-01",
      email: "ana@example.com",
      password: "password",
      numeroutent: "123456789",
      createdAt: "2023-01-01",
      updatedAt: "2023-01-01",
      specialty: "Cardiologia",
      rating: 3,
      imageUrl: "https://example.com/images/ana.png",
    ),
    Doctor(
      id: 2,
      name: "Bruno Rodrigues",
      gender: "Male",
      birthdate: "1985-05-15",
      email: "bruno@example.com",
      password: "password",
      numeroutent: "987654321",
      createdAt: "2023-01-01",
      updatedAt: "2023-01-01",
      specialty: "Dermatologia",
      rating: 4,
      imageUrl: "https://example.com/images/bruno.png",
    ),
    Doctor(
      id: 3,
      name: "Catarina Marques",
      gender: "Female",
      birthdate: "1988-12-20",
      email: "catarina@example.com",
      password: "password",
      numeroutent: "456789123",
      createdAt: "2023-01-01",
      updatedAt: "2023-01-01",
      specialty: "Neurologia",
      rating: 5,
      imageUrl: "https://example.com/images/catarina.png",
    ),
  ];

  List<Doctor> filteredDoctors = []; // Holds the filtered list

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize filteredDoctors with allDoctors initially
    filteredDoctors.addAll(allDoctors);
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
        final name = doctor.name.toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
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
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Pesquisar Médico(a)',
                  border: OutlineInputBorder(),
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
                        filteredDoctors[index].name,
                        style: const TextStyle(fontSize: 20),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filteredDoctors[index].specialty,
                            style: const TextStyle(fontSize: 16),
                          ),
                          _buildRatingStars(filteredDoctors[index].rating),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DoctorInfo(
                                    doctor: filteredDoctors[index],
                                  )),
                        );
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
        label: const Text('Ordenar e Filtrar'),
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

  Map<String, PropertySelector<Doctor>> propertyMap = {
    'name': (Doctor doctor) => doctor.name,
    'specialty': (Doctor doctor) => doctor.specialty,
    'ranking': (Doctor doctor) => doctor.rating,
  };

  List<Doctor> sortDoctors(
      List<Doctor> doctors, String? sortBy, bool isAscending) {
    if (sortBy != null && propertyMap.containsKey(sortBy)) {
      doctors.sort((a, b) {
        final aValue = propertyMap[sortBy]!(a);
        final bValue = propertyMap[sortBy]!(b);
        return Comparable.compare(aValue, bValue);
      });

      if (!isAscending) {
        doctors = doctors.reversed.toList();
      }
    }
    return doctors;
  }

  List<Doctor> filterDoctors(List<Doctor> doctors,
      List<String> selectedSpecialties, List<int> selectedRatings) {
    if (selectedSpecialties.isNotEmpty) {
      doctors = doctors
          .where((doctor) => selectedSpecialties.contains(doctor.specialty))
          .toList();
    }

    if (selectedRatings.isNotEmpty) {
      doctors = doctors
          .where((doctor) => selectedRatings.contains(doctor.rating))
          .toList();
    }

    return doctors;
  }

  void _showSortFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SortFilterDoctorsDialog(
          allDoctors: allDoctors,
          onApply: (sortBy, isAscending, selectedSpecialties, selectedRatings) {
            setState(() {
              List<Doctor> tempDoctors = allDoctors;

              tempDoctors = filterDoctors(
                  tempDoctors, selectedSpecialties, selectedRatings);
              tempDoctors = sortDoctors(tempDoctors, sortBy, isAscending);

              // Set the filteredDoctors to the newly filtered and sorted list
              filteredDoctors = tempDoctors;
            });

            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }
}

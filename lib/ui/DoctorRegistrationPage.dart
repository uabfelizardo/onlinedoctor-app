import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:onlinedoctorapp/services/DoctorService.dart';
import 'package:onlinedoctorapp/services/UserService.dart';
import 'package:onlinedoctorapp/ui/HomePage.dart';

class DoctorRegistrationPage extends StatefulWidget {
  const DoctorRegistrationPage({Key? key, required this.userID})
      : super(key: key);

  final String userID;

  @override
  _DoctorRegistrationPageState createState() => _DoctorRegistrationPageState();
}

class _DoctorRegistrationPageState extends State<DoctorRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();
  final TextEditingController _prefixController = TextEditingController();

  String _selectedGender = 'Male';
  List<String> _specialties = [];
  String? _selectedSpecialty;
  String _role = '';

  final List<String> _prefixes = ['Dr.', 'Dra.'];
  String _selectedPrefix = 'Dr.';

  XFile? _pickedImage;
  Uint8List? _doctorImageBytes;

  @override
  void initState() {
    super.initState();
    _fetchUserSpecialties();
    _fetchUserData();
  }

  Future<void> _fetchUserSpecialties() async {
    try {
      final specialties = await DoctorService.geDoctorSpecialties();
      setState(() {
        _specialties = specialties;
      });
    } catch (error) {
      print('Failed to load user specialties: $error');
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final userData =
          await UserService().getUserById(int.parse(widget.userID));
      setState(() {
        _prefixController.text = userData['prefix'] ?? 'Dr.';
        _firstNameController.text = userData['firstName'] ?? '';
        _lastNameController.text = userData['lastName'] ?? '';
        _usernameController.text = userData['username'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _contactController.text = userData['contact'] ?? '';
        _addressController.text = userData['address'] ?? '';
        _dateOfBirthController.text = userData['birthdate'] ?? '';
        _selectedGender = userData['gender'] ?? 'Male';
        _passwordController.text = userData['password'] ?? '';
        _confirmPasswordController.text = userData['password'] ?? '';
        _selectedSpecialty = userData['speciality'] ?? _specialties.first;
        _additionalInfoController.text = userData['additionalInfomation'] ?? '';
        // _doctorImageURL = userData['img'];
        _role = userData['role'] ?? '';

        // Decodificar a imagem base64
        if (userData['img'] != null) {
          _doctorImageBytes = base64Decode(userData['img'].split(',').last);
        }
      });
    } catch (error) {
      print('Failed to load user data: $error');
    }
  }

  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Converter a imagem para bytes
        List<int> imageBytes = [];
        if (_pickedImage != null) {
          imageBytes = await _pickedImage!.readAsBytes();
        }

        Map<String, dynamic> userData = {
          'prefix': _selectedPrefix,
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'username': _usernameController.text,
          'gender': _selectedGender,
          'birthdate': _dateOfBirthController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'contact': _contactController.text,
          'address': _addressController.text,
          'speciality': _selectedSpecialty,
          'img': imageBytes, // Grava a imagem como bytes
        };

        await UserService().updateUser(int.parse(widget.userID), userData);

        // Após atualizar os dados do usuário, chame a função para adicionar informações adicionais e especialidade
        await addAdditionalInformation();
        await addSpeciality();

        // Se tudo ocorrer bem, redirecione para a página inicial
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userName: _prefixController.text +
                  ' ' +
                  _firstNameController.text +
                  ' ' +
                  _lastNameController.text,
              userType: _role,
              userID: widget.userID.toString(),
              specialty: '',
            ),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user: $error')),
        );
      }
    }
  }

  Future<void> addAdditionalInformation() async {
    try {
      // Adiciona a informação adicional do médico
      final doctorInformationResponse =
          await DoctorService.addDoctorInformation({
        'additionalInformation': _additionalInfoController.text,
        'user_id': int.parse(widget.userID),
      });

      if (doctorInformationResponse != null) {
        print('Doctor information saved successfully');
        // Mostra um SnackBar de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Doctor information saved successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Redireciona para a página de login ou outra ação
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userName: _prefixController.text +
                  ' ' +
                  _firstNameController.text +
                  ' ' +
                  _lastNameController.text,
              userType: _role,
              userID: widget.userID.toString(),
              specialty: '',
            ),
          ),
        );
      } else {
        print('Failed to save doctor information');
        throw Exception('Failed to save doctor information');
      }
    } catch (e, stackTrace) {
      print('Failed to add additional information: $e');
      print(stackTrace);
      // Mostra um SnackBar de falha
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to add additional information'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> addSpeciality() async {
    try {
      // Obtém o ID da especialidade selecionada na dropdownlist
      final specialtyDescription = _selectedSpecialty;
      final specialtyId = await DoctorService.getSpecialityIdByDescription(
          specialtyDescription!);

      if (specialtyId == null) {
        throw Exception('Speciality not found');
      }

      // Cria a associação doctorSpeciality
      final specialityResponse = await DoctorService.addDoctorSpeciality({
        'date': DateTime.now().toString(),
        'user_id': int.parse(widget.userID),
        'speciality_id': specialtyId,
      });

      // Verifica se a associação foi criada com sucesso
      if (specialityResponse != null) {
        print('DoctorSpeciality saved successfully');
        // Adiciona a informação adicional do médico
        final doctorInformationResponse =
            await DoctorService.addDoctorInformation({
          'additionalInformation': _additionalInfoController.text,
          'user_id': int.parse(widget.userID),
        });

        if (doctorInformationResponse != null) {
          print('Doctor information saved successfully');
          // Redireciona para a página de login ou outra ação
          // MaterialPageRoute(
          //   builder: (context) => HomePage(
          //     userName:
          //         '${_prefixController.text} ${_firstNameController.text} ${_lastNameController.text}',
          //     userType: _role,
          //     userID: widget.userID.toString(),
          //     specialty: '',
          //   ),
          // );
        } else {
          throw Exception('Failed to save doctor information');
        }
      } else {
        throw Exception('Failed to save DoctorSpeciality');
      }
    } catch (e) {
      print('Failed to add speciality: $e');
      // Mostra um SnackBar de falha com mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add speciality: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Doctor Registration'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.purple,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 60.0),
                      const Text(
                        "Doctor Registration",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: _doctorImageBytes != null
                              ? ClipOval(
                                  child: Image.memory(
                                    _doctorImageBytes!,
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 120,
                                  ),
                                )
                              : Icon(Icons.camera_alt, size: 60),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Create your doctor account",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                fillColor: Colors.purple.withOpacity(0.1),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: const Icon(Icons.title),
                              ),
                              value: _selectedPrefix,
                              hint: const Text("Select Prefix"),
                              items: _prefixes.map((String prefix) {
                                return DropdownMenuItem<String>(
                                  value: prefix,
                                  child: Text(prefix),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedPrefix = newValue!;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a prefix';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                hintText: "First Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: Colors.purple.withOpacity(0.1),
                                filled: true,
                                prefixIcon: const Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          hintText: "Last Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.purple.withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _dateOfBirthController,
                        decoration: InputDecoration(
                          hintText: "Date of Birth",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.purple.withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              _dateOfBirthController.text = formattedDate;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your date of birth';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          hintText: "Address",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.purple.withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.home),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: "Username",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.purple.withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.purple.withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _contactController,
                        decoration: InputDecoration(
                          hintText: "Contact",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.purple.withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your contact number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.purple.withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.purple.withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          fillColor: Colors.purple.withOpacity(0.1),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.local_hospital),
                        ),
                        value: _selectedSpecialty,
                        hint: const Text("Select specialty"),
                        items: _specialties.map((String specialty) {
                          return DropdownMenuItem<String>(
                            value: specialty,
                            child: Text(specialty),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSpecialty = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _additionalInfoController,
                        decoration: InputDecoration(
                          hintText: "Additional Information",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.purple.withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.info),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    child: ElevatedButton(
                      onPressed: _updateUserData,
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.purple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

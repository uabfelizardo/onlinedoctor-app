import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:onlinedoctorapp/model/user.dart';
import 'package:onlinedoctorapp/services/UserService.dart';
import 'LoginPage.dart';
import 'package:onlinedoctorapp/services/UserRoleService.dart';
import 'package:onlinedoctorapp/services/DoctorService.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedUserType = 'Patient'; // Definir como 'Patient' por padrão
  String _selectedGender = 'Male';
  List<String> _userTypes = []; // Inicializa a lista de tipos de usuário vazia
  List<String> _specialties = []; // Inicializa a lista de especialidades vazia
  String?
      _selectedSpecialty; // Inicializa a especialidade selecionada como nula
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  DateTime _currentDtaeTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchUserRoles(); // Chama o método para buscar os tipos de usuário
    _fetchUserSpecialties(); // Chama o método para buscar as especialidades
  }

  Future<void> _fetchUserRoles() async {
    try {
      final roles = await UserRoleService.getUserRoles();
      setState(() {
        _userTypes = roles;
      });
    } catch (error) {
      print('Failed to load user roles: $error');
    }
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

  Future<void> saveUser() async {
    try {
      final userService = UserService(); // Instância do UserService
      final userRoleService = UserRoleService(); // Instância do UserService
      final response = await userService.addUser({
        'name': _usernameController.text,
        'gender': _selectedGender.toString(),
        'email': _emailController.text,
        'password': _passwordController.text,
        'createdAt': _currentDtaeTime.toString(),
      });
      // Verifica a resposta
      if (response != null) {
        print('User saved successfully');

        // Obtém o ID do usuário recém-criado
        final userId = response['id'];

        // Obtém o ID do role selecionado na dropdownlist
        final roleDescription = _selectedUserType;
        final roleId =
            await userRoleService.getRoleIdByDescription(roleDescription);

        // Cria a associação userrole
        final roleResponse = await userRoleService.addUserRole({
          'date': DateTime.now().toString(),
          'user_id': userId,
          'role_id': roleId,
        });

        if (roleResponse != null) {
          print('UserRole saved successfully');
        } else {
          throw Exception('Failed to save UserRole');
        }
      } else {
        throw Exception('Failed to save user');
      }
    } catch (error) {
      throw Exception('Failed to save user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                        "Sign up",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Create your account",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: "Name",
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
                            return 'Please enter your name';
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
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          fillColor: Colors.purple.withOpacity(0.1),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        value: _selectedUserType,
                        hint: const Text("Select user type"),
                        items: _userTypes.map((String userType) {
                          return DropdownMenuItem<String>(
                            value: userType,
                            child: Text(userType),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedUserType = newValue!;
                            if (_selectedUserType != 'Doctor') {
                              _selectedSpecialty =
                                  null; // Limpa a especialidade se não for 'Doctor'
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a user type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      if (_selectedUserType == 'Doctor')
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
                          validator: (value) {
                            if (_selectedUserType == 'Doctor' &&
                                value == null) {
                              return 'Please select a specialty';
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          const Text("Gender:"),
                          Expanded(
                            child: ListTile(
                              title: const Text('Male'),
                              leading: Radio<String>(
                                value: 'Male',
                                groupValue: _selectedGender,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedGender = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('Female'),
                              leading: Radio<String>(
                                value: 'Female',
                                groupValue: _selectedGender,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedGender = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
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
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Process data
                          saveUser();
                        }
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.purple,
                      ),
                    ),
                  ),
                  const Center(child: Text("Or")),
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.purple,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset:
                              const Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30.0,
                            width: 30.0,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('/onlinedoctor.png'),
                                fit: BoxFit.cover,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 18),
                          const Text(
                            "Sign In with Google",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.purple),
                        ),
                      ),
                    ],
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

void main() {
  runApp(const SignupPage());
}

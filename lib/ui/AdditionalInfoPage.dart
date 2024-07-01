import 'package:flutter/material.dart';

class AdditionalInfoPage extends StatefulWidget {
  final int userId;
  final String name;

  const AdditionalInfoPage({Key? key, required this.userId, required this.name})
      : super(key: key);

  @override
  _AdditionalInfoPageState createState() => _AdditionalInfoPageState();
}

class _AdditionalInfoPageState extends State<AdditionalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _additionalInfoController =
      TextEditingController();

  Future<void> saveAdditionalInfo() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Aqui você pode enviar a informação adicional para o backend
        // Por exemplo:
        // await PatientService.addAdditionalInfo(widget.userId, _additionalInfoController.text);

        print(
            "Additional info saved for user ${widget.userId}: ${_additionalInfoController.text}");
        // Exibir uma mensagem de sucesso ou redirecionar o usuário conforme necessário
      } catch (error) {
        print('Failed to save additional info: $error');
        // Exibir uma mensagem de erro conforme necessário
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Additional Info for ${widget.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'User ID: ${widget.userId}',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _additionalInfoController,
                decoration: InputDecoration(
                  labelText: 'Additional Information',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.purple.withOpacity(0.1),
                  filled: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the additional information';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveAdditionalInfo,
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.purple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AdditionalInfoPage(userId: 1, name: 'John Doe'),
    debugShowCheckedModeBanner: false,
  ));
}

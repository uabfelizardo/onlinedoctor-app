import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:onlinedoctorapp/ui/DoctorListPage.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) => DashboardCard(
            icon: _getIcon(index),
            label: _getLabel(index),
            onPressed: () {
              // Defina a ação de navegação para cada botão
              _navigateToPage(context, index);
            },
          ),
          staggeredTileBuilder: (int index) =>
              StaggeredTile.count(2, index.isEven ? 2 : 1),
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DoctorListPage()),
        );
        break;
      // Adicione a navegação para as outras páginas aqui
      // case 1:
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => AdicionarMedicamentoPage()),
      //   );
      //   break;
      // case 2:
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => AdicionarFarmaciaPage()),
      //   );
      //   break;
      // case 3:
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => AdicionarHospitalPage()),
      //   );
      //   break;
      default:
        break;
    }
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.access_time;
      case 1:
        return Icons.medical_services;
      case 2:
        return Icons.local_pharmacy;
      case 3:
        return Icons.local_hospital;
      default:
        return Icons.help;
    }
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'Disponibilidade do Médico';
      case 1:
        return 'Adicionar Medicamento';
      case 2:
        return 'Adicionar Farmácia';
      case 3:
        return 'Adicionar Hospital';
      default:
        return 'Outro';
    }
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const DashboardCard({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 8.0,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48.0,
                color: Colors.purple,
              ),
              SizedBox(height: 16.0),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
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
    debugShowCheckedModeBanner: false,
    home: SettingsPage(),
  ));
}

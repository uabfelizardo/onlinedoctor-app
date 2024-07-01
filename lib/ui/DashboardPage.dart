import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'PatientListPage.dart'; // Importa a página PatientListPage
import 'AppointmentList.dart'; // Importa a página AppointmentListPage
import 'HospitalMapPage.dart'; // Importa a página HospitalMapPage

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 2, // Ajustado para 2 colunas
          itemCount: 6, // Ajustado para 6 itens
          itemBuilder: (BuildContext context, int index) {
            return DashboardCard(
              icon: _getIcon(index),
              label: _getLabel(index),
              onPressed: () {
                _navigateToPage(context, index); // Chama a função de navegação
              },
            );
          },
          staggeredTileBuilder: (int index) => StaggeredTile.count(
              1, index == 4 || index == 5 ? 1 : 2), // Ajuste nas tiles
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
        ),
      ),
    );
  }

  // Função para retornar o ícone correspondente ao índice
  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.list_alt; // Ícone para Lista de Pacientes
      case 1:
        return Icons.calendar_today; // Ícone para Agenda
      case 2:
        return Icons.bar_chart; // Ícone para Relatórios
      case 3:
        return Icons.settings; // Ícone para Configurações
      case 4:
        return Icons.location_on; // Ícone para Geolocalização de Hospitais
      case 5:
        return Icons.help; // Ícone para Help
      default:
        return Icons.help;
    }
  }

  // Função para retornar o rótulo correspondente ao índice
  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'Lista de Pacientes'; // Rótulo para Lista de Pacientes
      case 1:
        return 'Agenda'; // Rótulo para Agenda
      case 2:
        return 'Relatórios'; // Rótulo para Relatórios
      case 3:
        return 'Configurações'; // Rótulo para Configurações
      case 4:
        return 'Geolocalização de Hospitais'; // Rótulo para Geolocalização de Hospitais
      case 5:
        return 'Help'; // Rótulo para Help
      default:
        return 'Help';
    }
  }

  // Função para navegar para a página correspondente ao índice
  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PatientListPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AppointmentListPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HospitalMapPage()),
        );
        break;
      case 5:
        // Implemente a navegação para a página de Help aqui
        break;
      // Adicione outros cases aqui para outras navegações, se necessário
      default:
        break;
    }
  }
}

// Widget para exibir cada card na grade
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
    return SizedBox(
      width: 25.0, // Largura fixa para todos os cards
      height: 25.0, // Altura fixa para todos os cards
      child: Card(
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
                  size: 100.0, // Tamanho fixo para todos os ícones
                  color: Colors.purple,
                ),
                SizedBox(height: 20.0),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.0, // Tamanho de fonte ajustado
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Função principal que inicia o aplicativo
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DashboardPage(), // Define a página inicial como DashboardPage
  ));
}

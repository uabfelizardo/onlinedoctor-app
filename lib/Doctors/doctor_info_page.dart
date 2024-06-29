import 'package:flutter/material.dart';
import 'package:onlinedoctorapp/base_page.dart';
import 'package:onlinedoctorapp/model/doctor.dart';

class DoctorInfo extends StatelessWidget {
  final Doctor doctor;

  const DoctorInfo({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Visualizar Médico',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Center(child: Text('[imagem]')),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nome:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(doctor.name),
                    const SizedBox(height: 8),
                    const Text('Especialidades:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(doctor.specialty),
                    const SizedBox(height: 8),
                    Text('Rating: ${doctor.rating}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: FloatingActionButton.extended(
                onPressed: () {
                  //
                },
                icon: const Icon(Icons.filter_list),
                label: const Text('Consultar Disponibilidade'),
              ),
            ),
            const Divider(thickness: 1, color: Colors.black),
            const SizedBox(height: 16),
            const Text('Avaliações',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildReviewItem(),
                  _buildReviewItem(),
                  _buildReviewItem(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
                child: const Center(child: Text('[imagem]')),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('[Avaliação]',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('[Nome]'),
                ],
              ),
              const Spacer(),
              const Text('[Data e Hora]'),
            ],
          ),
          const SizedBox(height: 8),
          const Text('[Comentário]'),
          const Divider(thickness: 1, color: Colors.grey),
        ],
      ),
    );
  }
}

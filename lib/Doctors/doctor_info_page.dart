import 'package:flutter/material.dart';
import 'package:onlinedoctorapp/base_page.dart';
import 'package:onlinedoctorapp/model/doctor.dart';
import 'package:onlinedoctorapp/model/review.dart';
import 'package:onlinedoctorapp/services/doctor_service.dart';

class DoctorInfo extends StatefulWidget {
  final Doctor doctor;

  const DoctorInfo({Key? key, required this.doctor}) : super(key: key);

  @override
  DoctorInfoState createState() => DoctorInfoState();
}

class DoctorInfoState extends State<DoctorInfo> {
  List<UserReview> reviews = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDoctorReviews(widget.doctor.id);
  }

  Future<void> _fetchDoctorReviews(int doctorId) async {
    try {
      if (mounted) {
        List<UserReview> fetchedReviews =
            await DoctorService.getDoctorReviews(doctorId);
        setState(() {
          reviews = fetchedReviews;
          isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load reviews: $error')),
        );
      }
    }
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
              'Visualizar Médico',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
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
                    Text(widget.doctor.name),
                    const SizedBox(height: 8),
                    const Text('Especialidades:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.doctor.specialty),
                    const SizedBox(height: 8),
                    Text('Rating: ${widget.doctor.rating}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            const Text(
              'Avaliações',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return _buildReviewItem(reviews[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(UserReview review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Ensure text starts from the left
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review.user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const Spacer(),
              Text('${review.reviewDate}'),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.reviewText,
            textAlign: TextAlign.left,
          ),
          const Divider(thickness: 1, color: Colors.grey),
        ],
      ),
    );
  }
}

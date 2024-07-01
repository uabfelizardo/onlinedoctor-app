import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class DocumentService {
  final String baseUrl;

  DocumentService(this.baseUrl);

  Future<void> addDocument({
    required String document,
    required DateTime date,
    required int appointmentId,
  }) async {
    var url = Uri.parse('$baseUrl/document');

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'document': document,
        'date': date.toIso8601String(),
        'appointment_id': appointmentId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add document');
    }
  }

  Future<void> updateDocument({
    required int id,
    required String document,
    required DateTime date,
    required int appointmentId,
  }) async {
    var url = Uri.parse('$baseUrl/document/$id');

    var response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'document': document,
        'date': date.toIso8601String(),
        'appointment_id': appointmentId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update document');
    }
  }

  Future<void> deleteDocument(int id) async {
    var url = Uri.parse('$baseUrl/document/$id');

    var response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete document');
    }
  }

  Future<void> saveAttachedDocuments({
    required List<File> documents,
    required DateTime date,
    required int appointmentId,
  }) async {
    var uri = Uri.parse('$baseUrl/document');

    var request = http.MultipartRequest('POST', uri);

    // Add appointment ID and date as fields
    request.fields['appointment_id'] = appointmentId.toString();
    request.fields['date'] = date.toIso8601String();

    // Add files
    for (var file in documents) {
      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      var multipartFile = http.MultipartFile(
        'document',
        stream,
        length,
        filename: basename(file.path),
      );
      request.files.add(multipartFile);
    }

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to save attached documents');
    }
  }
}

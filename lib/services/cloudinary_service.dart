import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  static const String _cloudName = 'bsa2xrur';
  static const String _uploadPreset = 'firebase_cloudinary';

  Future<String> uploadImage(XFile image) async {
    final uri = Uri.https(
      'api.cloudinary.com',
      '/v1_1/$_cloudName/image/upload',
    );
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          await image.readAsBytes(),
          filename: image.name,
        ),
      );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final responseBody = jsonDecode(response.body);

    if (responseBody is! Map<String, dynamic>) {
      throw const FormatException('Cloudinary returned an invalid response.');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = responseBody['error'];
      final message = error is Map<String, dynamic> ? error['message'] : null;
      throw Exception(
        message is String ? message : 'HTTP ${response.statusCode}',
      );
    }

    final secureUrl = responseBody['secure_url'];
    if (secureUrl is! String || secureUrl.isEmpty) {
      throw const FormatException(
        'Cloudinary response did not contain an image URL.',
      );
    }
    return secureUrl;
  }
}

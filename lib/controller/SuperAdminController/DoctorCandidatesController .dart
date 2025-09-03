import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';

class DoctorCandidatesController extends GetxController {
  var candidates = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  Future<void> fetchCandidates(String search) async {
    try {
      isLoading(true);
      var response = await http.get(
        Uri.parse(AppLink.doctorCandidates(search)),
        headers: {
          'Authorization': 'Bearer ${AppLink.token}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        candidates.value = List<Map<String, dynamic>>.from(body['data']);
      } else {
        candidates.clear();
      }
    } catch (e) {
      print("Error fetching candidates: $e");
      candidates.clear();
    } finally {
      isLoading(false);
    }
  }
}

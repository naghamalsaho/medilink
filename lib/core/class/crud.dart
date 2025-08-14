import 'dart:convert';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/core/services/MyServices.dart';

import 'dart:io';
import 'package:path/path.dart';

class Crud {
  late MyServices myServices;
  late Map<String, String> headers;
  Crud() {
    myServices = Get.find<MyServices>();
    _initHeaders(); 
  }

  void _initHeaders() {
    final lang = myServices.box.read("lang") ?? "en";
    headers = {"Accept": "application/json", "Accept-Language": lang};

    String? token = myServices.box.read("token");
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
  }

  void Token() {
    String? token = myServices.box.read("token");
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<Map<String, dynamic>> postData(
    String linkurl,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(linkurl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      print("RAW RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body); 
      } else {
        return {"success": false, "message": "Connection failed"};
      }
    } catch (e) {
      return {"success": false, "message": " error: $e"};
    }
  }
Future<Uint8List> getImageWithToken(String url) async {
  try {
    _initHeaders();
    final response = await http.get(Uri.parse(url), headers: headers);
    
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    
    throw Exception("Failed to load image: ${response.statusCode}");
  } catch (e) {
    print("Image load error: $e");
    rethrow;
  }
}

   Future<Either<StatusRequest, Map>> getData(String linkurl) async {
    _initHeaders(); 
    var response = await http.get(Uri.parse(linkurl), headers: headers);
    print("GET Request to: $linkurl");
    print("Headers: $headers");
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map responsebody = jsonDecode(response.body);
      return Right(responsebody);
    } else {
      return const Left(StatusRequest.serverfailure);
    }
  }

   Future<Either<StatusRequest, Map<String, dynamic>>> postFileAndData(
    String url,
    Map<String, String> data,
    String fileField,
    Uint8List fileBytes,  
    String fileName,      
  ) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      
      data.forEach((key, value) {
        request.fields[key] = value;
      });
     
      request.files.add(http.MultipartFile.fromBytes(
        fileField,
        fileBytes,
        filename: fileName,
      ));
      
      
      if (myServices.box.hasData('token')) {
        request.headers['Authorization'] = 'Bearer ${myServices.box.read('token')}';
      }
      
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(jsonDecode(response.body));
      } else {
        return Left(StatusRequest.serverfailure);
      }
    } catch (e) {
      print("Post file error: $e");
      return Left(StatusRequest.serverfailure);
    }
  }

  
  Future<Map<String, dynamic>> postDataWithHeaders(
    String linkurl,
    Map<String, dynamic> data,
  ) async {
    try {
      
      _initHeaders();

      final requestHeaders = {
        ...headers, // Authorization, Accept, Accept-Language
        'Content-Type': 'application/json',
      };

      print(' [Crud] POST Request to: $linkurl');
      print(' [Crud] Headers: $requestHeaders');
      print(' [Crud] Body: $data');

      final response = await http.post(
        Uri.parse(linkurl),
        headers: requestHeaders,
        body: jsonEncode(data),
      );

      print(' [Crud] POST statusCode: ${response.statusCode}');
      print(' [Crud] POST raw response: ${response.body}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 422) {
        try {
          final Map<String, dynamic> decoded = jsonDecode(response.body);
          return decoded;
        } catch (e) {
          return {
            "success": false,
            "message": "Unable to parse response JSON",
            "raw": response.body
          };
        }
      } else if (response.statusCode == 401) {
        return {
          "success": false,
          "message": "Unauthorized (401)",
          "status": 401,
          "raw": response.body
        };
      } else {
        return {
          "success": false,
          "message": "  faluer (status ${response.statusCode})",
          "status": response.statusCode,
          "raw": response.body
        };
      }
    } catch (e, st) {
      print('🔥 [Crud] postDataWithHeaders exception: $e');
      print(st);
      return {"success": false, "message": " error: $e"};
    }
  }

  Future<Either<StatusRequest, Map>> postMutipleImagesAndData(
    String linkurl,
    Map data,
    String name,
    images,
    String? fileName,
    files,
  ) async {
    Token();
    var request = http.MultipartRequest('POST', Uri.parse(linkurl));

    request.headers.addAll(headers);
    for (int i = 0; i < files.length; i++) {
      request.files.add(
        http.MultipartFile(
          '$fileName[$i]',
          http.ByteStream(files[i].openRead()),
          await files[i].length(),
          filename: basename(files[i].path),
        ),
      );
    }

    for (int i = 0; i < images.length; i++) {
      request.files.add(
        http.MultipartFile(
          '$name[$i]',
          http.ByteStream(images[i].openRead()),
          await images[i].length(),
          filename: basename(images[i].path),
        ),
      );
    }

    data.forEach((key, value) {
      if (value is List<String>) {
        request.fields[key] = jsonEncode(value);
      } else {
        request.fields[key] = value.toString();
      }
    });

    var myRequest = await request.send();
    var response = await http.Response.fromStream(myRequest);

    if (myRequest.statusCode == 200 ||
        myRequest.statusCode == 201 ||
        myRequest.statusCode == 422) {
      return Right(jsonDecode(response.body));
    } else {
      print(response.body);
      return const Left(StatusRequest.serverfailure);
    }
  }

  Future<Either<StatusRequest, dynamic>> create(String linkurl, data) async {
    try {
      //if (await checkInternet()) {
      Token();
      headers['Content-Type'] = 'application/json';
      headers['Accept'] = 'application/pdf';
      var response = await http.post(
        Uri.parse(linkurl),
        headers: headers,
        body: data,
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        print("CRUUUUUUUUUUUUUUUUuuuuuuD $response.....");

        return Right(response);
      } else {
        return const Left(StatusRequest.serverfailure);
      }
      // } else {
      //   print("StatusRequest.offlinefailure");
      //   return const Left(StatusRequest.offlinefailure);
      // }
    } catch (_) {
      return const Left(StatusRequest.serverfailure);
    }
  }


    Future<http.Response> putData2(String url, Map<String, dynamic> data) async {
    try {
      Token();
      headers['Content-Type'] = 'application/json';
      final response = await http.put(
        Uri.parse(url),
        headers: headers, 
        body: jsonEncode(data),
      );

      print(" PUT Request to $url");
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response;
    } catch (e) {
      print(" PUT Error: $e");
      return http.Response('{"success": false, "message": "Error: $e"}', 500);
    }
  }

Future<Map<String, dynamic>> putData(
  String linkUrl,
  Map<String, dynamic> data,
) async {

  Token();

  try {
    final response = await http.put(
      Uri.parse(linkUrl),
      headers: {
        ...headers,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    print("PUT RAW RESPONSE: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      return {
        'success': false,
        'message': 'Update failed(status ${response.statusCode})'
      };
    }
  } catch (e) {
    return {'success': false, 'message': ' error: $e'};
  }
}
  Future<Either<StatusRequest, Map>> deleteData(String linkUrl) async {
    //  try {
    Token();
    var response = await http.delete(Uri.parse(linkUrl), headers: headers);
    print(response.statusCode);

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 401 ||
        response.statusCode == 400 ||
        response.statusCode == 422 ||
        response.statusCode == 500) {
      Map responsebody = jsonDecode(response.body);
      print("CRUD DELETE $responsebody .....");

      return Right(responsebody);
    } else {
      return const Left(StatusRequest.serverfailure);
    }
    // } catch (_) {
    //   return const Left(StatusRequest.serverfailure);
    // }
  }
  Future<Map<String, dynamic>> putWithToken(
    String linkurl,
    Map<String, dynamic> data,
  ) async {
    try {
      _initHeaders(); 

      final requestHeaders = {
        ...headers,
        'Content-Type': 'application/json',
      };

      print(' [Crud.putWithToken] PUT Request to: $linkurl');
      print(' [Crud.putWithToken] Headers: $requestHeaders');
      print('[Crud.putWithToken] Body: $data');

      final response = await http.put(
        Uri.parse(linkurl),
        headers: requestHeaders,
        body: jsonEncode(data),
      );

      print(' [Crud.putWithToken] statusCode: ${response.statusCode}');
      print(' [Crud.putWithToken] raw response: ${response.body}');

      try {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return decoded;
      } catch (e) {
        return {
          'success': false,
          'message': 'Unable to parse response JSON',
          'status': response.statusCode,
          'raw': response.body,
        };
      }
    } catch (e, st) {
      print(' [Crud.putWithToken] exception: $e');
      print(st);
      return {'success': false, 'message': ' error: $e'};
    }
  }

  
  Future<Map<String, dynamic>> deleteWithToken(String linkurl) async {
    try {
      _initHeaders();

      print(' [Crud.deleteWithToken] DELETE Request to: $linkurl');
      print(' [Crud.deleteWithToken] Headers: $headers');

      final response = await http.delete(Uri.parse(linkurl), headers: headers);

      print(' [Crud.deleteWithToken] statusCode: ${response.statusCode}');
      print(' [Crud.deleteWithToken] raw response: ${response.body}');

      try {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return decoded;
      } catch (e) {
        return {
          'success': false,
          'message': 'Unable to parse response JSON',
          'status': response.statusCode,
          'raw': response.body,
        };
      }
    } catch (e, st) {
      print('[Crud.deleteWithToken] exception: $e');
      print(st);
      return {'success': false, 'message': ' error: $e'};
    }
  }
}

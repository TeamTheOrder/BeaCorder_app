import 'dart:convert';

import 'package:beacorder/dto/beacon_detail.dart';
import 'package:http/http.dart' as http;
class ApiService {

  final String baseUrl;
  final http.Client httpClient;

  ApiService({this.baseUrl = "http://10.0.2.2:8080/api/v1/consumer", http.Client? httpClient})
      : this.httpClient = httpClient ?? http.Client();

  Future<List<BeaconDetail>> getStoreInfoList(List<String> uuid_list) async {

    List<BeaconDetail> return_list = [];
    Map body = {"uuid_list" : uuid_list};
    print(body.toString());
      final response = await httpClient.post(
        Uri.parse('$baseUrl/store'),
        headers: {"Content-Type" : "application/json"},
        body: jsonEncode(body)
      );

    print('------getStoreInfoList 함수 실행');
      List<dynamic> responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      return_list = responseJson.map((store) => BeaconDetail.fromJson(store)).toList();

      print(return_list[0].storeName);

      return return_list;
    }
}

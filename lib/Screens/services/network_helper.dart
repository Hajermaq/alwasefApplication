// import 'package:alwasef_app/Screens/services/prescription_model.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class FetchAPI {
//   Future<List<PrescriptionModel>> fetchPrescription() async {
//     http.Response response = await http.get(
//         "https://api.sheety.co/f3ab60de807a9b41dfd2088ac3c0be5d/databaseshort/drugs");
//     if (response.statusCode == 200) {
//       var jsonArray = json.decode(response.body);
//
//       print(jsonArray.length);
//
//       List<PrescriptionModel> drugs = [];
//
//       for (var obj in jsonArray) {
//         PrescriptionModel drug = PrescriptionModel(
//             obj["scientificName"],
//             obj["scientificNameArabic"],
//             obj["tradeName"],
//             obj["tradeNameArabic"],
//             obj["strengthUnit"],
//             obj["pharmaceuticalForm"],
//             obj["administrationRoute"],
//             obj["sizeUnit"],
//             obj["storageConditions"],
//             obj["strength"],
//             obj["publicPrice"],
//             obj["size"],
//             obj["id"]);
//         drugs.add(drug);
//       }
//       print(drugs.length);
//       return drugs;
//     } else {
//       print('unseccessful connection');
//     }
//   }
// }

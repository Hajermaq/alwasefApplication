import 'package:alwasef_app/Screens/services/user_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'prescription_model.dart';

class PrescriptionData extends ChangeNotifier {
  List<Prescription> prescriptions = [];

  int get prescriptionCount {
    return prescriptions.length;
  }

  void addPrescription(
    String scientificName,
    String scientificNameArabic,
    String tradeName,
    String tradeNameArabic,
    String strengthUnit,
    String pharmaceuticalForm,
    String administrationRoute,
    String sizeUnit,
    String storageConditions,
    String strength,
    String publicPrice,
    int size,
    int dose,
    int quantity,
    int refill,
    int dosingExpire,
    var frequency,
    String instructionNote,
    String doctorNotes,
    context,
  ) {
    var p = Prescription(
      scientificName,
      scientificNameArabic,
      tradeName,
      tradeNameArabic,
      strengthUnit,
      pharmaceuticalForm,
      administrationRoute,
      sizeUnit,
      storageConditions,
      strength,
      publicPrice,
      size,
      dose,
      quantity,
      refill,
      dosingExpire,
      frequency,
      instructionNote,
      doctorNotes,
    );
    prescriptions.add(p);
    notifyListeners();
  }
}

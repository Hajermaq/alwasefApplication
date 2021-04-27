class CheckInconsistencies {
  //drugs can not be taken at a time for a single patient
  String olanzapine = 'OLANZAPINE';
  String ciprofloxacin = 'CIPROFLOXACIN';

  String verapamil = 'VERAPAMIL ';
  String atenolol = 'ATENOLOL';

  String warfarin = 'WARFARIN';
  String acetylsalicylicacid = 'ACETYLSALICYLIC ACID';

  String apixaban = 'Apixaban'; //APIXABAN
  String rifampicin = 'RIFAMPICIN';

  String bisoprolol = 'BISOPROLOL';
  String deltiazim = 'DILTIAZEM';

  List<dynamic> checkInconsistency(List<dynamic> drugsToCheck) {
    // do this if prescriptions number is 2 or more
    if (drugsToCheck.length >= 2) {
      List<dynamic> inconsistentDrugs = [];

      if (drugsToCheck.contains(olanzapine) &&
          drugsToCheck.contains(ciprofloxacin)) {
        inconsistentDrugs.add([olanzapine, ciprofloxacin]);
      }
      if ((drugsToCheck.contains(verapamil) &&
          drugsToCheck.contains(atenolol))) {
        inconsistentDrugs.add([verapamil, atenolol]);
      }
      if ((drugsToCheck.contains(warfarin) &&
          drugsToCheck.contains(acetylsalicylicacid))) {
        inconsistentDrugs.add([warfarin, acetylsalicylicacid]);
      }
      if ((drugsToCheck.contains(apixaban) &&
          drugsToCheck.contains(rifampicin))) {
        inconsistentDrugs.add([apixaban, rifampicin]);
      }
      if ((drugsToCheck.contains(bisoprolol) &&
          drugsToCheck.contains(deltiazim))) {
        inconsistentDrugs.add([bisoprolol, deltiazim]);
      }
      // if no inconsistencies found
      if (inconsistentDrugs.isEmpty) {
        return ['no inconsistencies', drugsToCheck.length];
      } else {
        // if inconsistencies found
        return [inconsistentDrugs, drugsToCheck.length];
        //return inconsistentDrugs;
      }
      // if less than 2
    } else {
      return ['can not compare less than 2'];
    }
  }
}

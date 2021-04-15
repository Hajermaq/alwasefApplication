class CheckInconsistencies{

  //drugs can not be taken at a time for a single patient
  String olanzapine = 'Olanzapine';
  String ciprofloxacin = 'Ciprofloxacin';

  String verapamil = 'Verapamil';
  String atenolol = 'Atenolol';

  String warfarin = 'Warfarin';
  String acetylsalicylicacid = 'Acetylsalicylicacid';


  String apixaban = 'Apixaban';
  String rifampicin = 'Rifampicin';


  String bisoprolol = 'Bisoprolol';
  String deltiazim = 'Deltiazim';


  List<dynamic> check(List<dynamic> drugsToCheck){
    // do this if prescriptions number is 2 or more
    if(drugsToCheck.length >= 2){
      List<dynamic> inconsistentDrugs = [];
      if (drugsToCheck.contains(olanzapine) && drugsToCheck.contains(ciprofloxacin)){
        inconsistentDrugs.add([olanzapine, ciprofloxacin]);

      } else if ((drugsToCheck.contains(verapamil) && drugsToCheck.contains(atenolol))) {
        inconsistentDrugs.add([verapamil, atenolol]);

      } else if ((drugsToCheck.contains(warfarin) && drugsToCheck.contains(acetylsalicylicacid))) {
        inconsistentDrugs.add([warfarin,acetylsalicylicacid]);

      } else if ((drugsToCheck.contains(apixaban) && drugsToCheck.contains(rifampicin))) {
        inconsistentDrugs.add([apixaban, rifampicin]);

      } else if ((drugsToCheck.contains(bisoprolol) && drugsToCheck.contains(deltiazim))) {
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

class PrescriptionModel {
  String scientificName,
      scientificNameArabic,
      tradeName,
      tradeNameArabic,
      strengthUnit,
      pharmaceuticalForm,
      administrationRoute,
      sizeUnit,
      storageConditions;

  String strength, publicPrice;
  String size, id;

  PrescriptionModel(
      this.scientificName,
      this.scientificNameArabic,
      this.tradeName,
      this.tradeNameArabic,
      this.strengthUnit,
      this.pharmaceuticalForm,
      this.administrationRoute,
      this.sizeUnit,
      this.storageConditions,
      this.strength,
      this.publicPrice,
      this.size,
      this.id);

  PrescriptionModel.fromJason(Map<String, dynamic> map) {
    this.tradeName = map['tradeName'];
    this.size = map["Size"].toString();
    this.scientificName = map["scientificName"];
    this.scientificNameArabic = map['scientificNameArabic'];
    this.tradeNameArabic = map['tradeNameArabic'];
    this.strength = map['Strength'];
    this.strengthUnit = map['StrengthUnit'];
    this.pharmaceuticalForm = map['PharmaceuticalForm'];
    this.administrationRoute = map['AdministrationRoute'];
    this.sizeUnit = map['SizeUnit'];
    this.publicPrice = map['Public price'];
    this.storageConditions = map['Storage conditions'];
  }
}

class Prescription {
  String scientificName,
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
      instructionNote,
      doctorNotes;

  int dose, quantity, refill, dosingExpire, size;

  var frequency;

  Prescription(
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
    this.dose,
    this.quantity,
    this.refill,
    this.dosingExpire,
    this.frequency,
    this.instructionNote,
    this.doctorNotes,
  );
}

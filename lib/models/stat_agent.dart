class StatAgentModel {
  int? id;
  String? matricule;
  String? name;
  String? surname;
  int? pv;
  int? qp;
  int? montant;
  int? week;
  String? dateJour;
  String? jour;

  StatAgentModel({
    this.id,
    this.matricule,
    this.name,
    this.surname,
    this.pv,
    this.qp,
    this.montant,
    this.week,
    this.dateJour,
    this.jour,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matricule': matricule,
      'name': name,
      'surname': surname,
      'pv': pv,
      'qp': qp,
      'montant': montant,
      'week': week,
      'dateJour': dateJour,
      'jour': jour,
    };
  }
}

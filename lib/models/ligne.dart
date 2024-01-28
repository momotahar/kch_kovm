
class Ligne {
  int? id;
  String? ligne;
  String? service;
  String? busTram;
  String? montee;
  String? heureMontee;
  String? descente;
  String? heureDescente;
  int? voyageurs;
  int? pv;
  String? dateJour;

  Ligne(
      {this.id,
      this.ligne,
      this.service,
      this.busTram,
      this.montee,
      this.heureMontee,
      this.descente,
      this.heureDescente,
      this.voyageurs,
      this.pv,
      this.dateJour});
  // Constructor with a subset of properties
  Ligne.montee({
    required this.id,
    required this.ligne,
    required this.service,
    required this.busTram,
    required this.montee,
    required this.heureMontee,
    required this.dateJour,
  });
  // Constructor with a subset of properties
  Ligne.descente({
    required this.descente,
    required this.heureDescente,
    required this.voyageurs,
    required this.pv,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ligne': ligne,
      'service': service,
      'busTram': busTram,
      'montee': montee,
      'heureMontee': heureMontee,
      'descente': descente,
      'heureDescente': heureDescente,
      'voyageurs': voyageurs,
      'pv': pv,
      'dateJour': dateJour
    };
  }

  factory Ligne.fromMap(Map<String, dynamic> map) {
    return Ligne(
        id: map['id'],
        ligne: map['ligne'],
        service: map['service'],
        busTram: map['busTram'],
        montee: map['montee'],
        heureMontee: map['heureMontee'],
        descente: map['descente'],
        heureDescente: map['heureDescente'],
        voyageurs: map['voyageurs'],
        pv: map['pv'],
        dateJour: map['dateJour']);
  }
}

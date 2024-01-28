class AgentModel {
  int? id;
  String? name;
  String? surname;
  String? matricule;

  AgentModel({
    this.id,
    this.name,
    this.surname,
    this.matricule,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'matricule': matricule,
    };
  }
}

class Rapport {
  String? equipe;
  String? dateJour;
  String? priseService;
  String? depart;
  String? pause;
  String? finService;
  String? observations;

  Rapport({
    this.equipe,
    this.dateJour,
    this.priseService,
    this.depart,
    this.pause,
    this.finService,
    this.observations,
  });
  // Constructor with a subset of properties
  Rapport.debut({
    this.equipe,
    this.dateJour,
    this.priseService,
    this.depart,
  });
  // Constructor with a subset of properties
  Rapport.fin({ this.pause, this.finService, this.observations});

  Map<String, dynamic> toMap() {
    return {
      'equipe': equipe,
      'dateJour': dateJour,
      'priseService': priseService,
      'depart': depart,
      'pause': pause,
      'finService': finService,
      'observations': observations,
    };
  }

  factory Rapport.fromMap(Map<String, dynamic> map) {
    return Rapport(
      equipe: map['equipe'],
      dateJour: map['dateJour'],
      priseService: map['priseService'],
      depart: map['depart'],
      pause: map['pause'],
      finService: map['finService'],
      observations: map['observations'],
    );
  }
}

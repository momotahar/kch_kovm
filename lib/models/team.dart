class TeamModel {
  String? equipe;
  String? email;
  String? password;

  TeamModel({
    required this.equipe,
    required this.email,
    required this.password,
  });

  TeamModel.fromEmailAndPassword({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'equipe': equipe,
      'email': email,
      'password': password,
    };
  }
}

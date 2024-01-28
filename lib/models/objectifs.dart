class Objectifs {
  int? tram;
  int? bus483;
  int? bus482;
  int? bus480;
  int? bus282;
  int? busLicorne;

  Objectifs({
    this.tram,
    this.bus483,
    this.bus482,
    this.bus480,
    this.bus282,
    this.busLicorne,
  });

  factory Objectifs.fromJson(Map<String, dynamic> json) {
    return Objectifs(
      tram: json['tram'],
      bus483: json['bus483'],
      bus482: json['bus482'],
      bus480: json['bus480'],
      bus282: json['bus282'],
      busLicorne: json['busLicorne'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tram': tram,
      'bus483': bus483,
      'bus482': bus482,
      'bus480': bus480,
      'bus282': bus282,
      'busLicorne': busLicorne,
    };
  }
}

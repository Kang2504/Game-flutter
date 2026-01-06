class GameCase {
  final int id;
  final String title;
  final String description;
  final List<String> clues;
  final List<String> testimony;
  final int? correctSuspectId;

  GameCase({
    required this.id,
    required this.title,
    required this.description,
    required this.clues,
    required this.testimony,
    this.correctSuspectId,
  });

  factory GameCase.fromJson(Map<String, dynamic> json) {
    return GameCase(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      clues: List<String>.from(json['clues'] ?? []),
      testimony: List<String>.from(json['testimony'] ?? []),
      correctSuspectId: json['correct_suspect_id'],
    );
  }
}

class Suspect {
  final int id;
  final int caseId;
  final String name;
  final String description;
  final String personality;
  final String? imageUrl;

  Suspect({
    required this.id,
    required this.caseId,
    required this.name,
    required this.description,
    required this.personality,
    this.imageUrl,
  });

  factory Suspect.fromJson(Map<String, dynamic> json) {
    return Suspect(
      id: json['id'],
      caseId: json['case_id'],
      name: json['name'],
      description: json['description'] ?? '',
      personality: json['personality'] ?? '',
      imageUrl: json['image_url'],
    );
  }
}

class Weapon {
  final int id;
  final int caseId;
  final String name;
  final String description;
  final String? imageUrl;
  final String material;

  Weapon({
    required this.id,
    required this.caseId,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.material,
  });

  factory Weapon.fromJson(Map<String, dynamic> json) {
    return Weapon(
      id: json['id'],
      caseId: json['case_id'],
      name: json['name'],
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      material: json['material'],
    );
  }
}

class Room {
  final int id;
  final int caseId;
  final String name;
  final String description;
  final String? imageUrl;
  final String inout;

  Room({
    required this.id,
    required this.caseId,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.inout,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      caseId: json['case_id'],
      name: json['name'],
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      inout: json['inout'],
    );
  }
}
class GameCase {
  final int id;
  final String title;
  final String description;
  final List<String> clues;
  final List<String> testimony;
  final int? correctSuspectId;
  final List<Suspect> suspects;
  final List<Weapon> weapons;
  final List<Room> rooms;
  final int? correctWeaponId;
  final int? correctRoomId;

  GameCase({
    required this.id,
    required this.title,
    required this.description,
    required this.clues,
    required this.testimony,
    required this.suspects,
    required this.weapons,
    required this.rooms,
    this.correctSuspectId,
    this.correctWeaponId,
    this.correctRoomId,
  });

  factory GameCase.fromJson(Map<String, dynamic> json) {
    return GameCase(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      clues: List<String>.from(json['clues'] ?? []),
      testimony: List<String>.from(json['testimony'] ?? []),
      suspects: (json['suspects'] as List).map((e) => Suspect.fromJson(e)).toList(),
      weapons: (json['weapons'] as List).map((e) => Weapon.fromJson(e)).toList(),
      rooms: (json['rooms'] as List).map((e) => Room.fromJson(e)).toList(),
      correctSuspectId: json['correct_suspect_id'],
      correctWeaponId: json['correct_weapon_id'],
      correctRoomId: json['correct_room_id'],
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

class ProfileModel {
  final String id; 
  final DateTime createdAt;
  final int lastClearedCase;

  ProfileModel({
    required this.id,
    required this.createdAt,
    required this.lastClearedCase,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] ?? '',
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      lastClearedCase: (map['last_cleared_case'] as int?) ?? 0,
    );
  }
}

class UserProgress {
  final String id;
  final String userId;
  final int caseId;
  final Map<String, dynamic> matrixState;
  final bool isCompleted;
  final DateTime createdAt;

  UserProgress({
    required this.id,
    required this.userId,
    required this.caseId,
    required this.matrixState,
    required this.isCompleted,
    required this.createdAt,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      id: json['id'],
      userId: json['user_id'],
      caseId: json['case_id'] as int,
      matrixState: json['matrix_state'] as Map<String, dynamic>? ?? {},
      isCompleted: json['is_completed'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'case_id': caseId,
    'matrix_state': matrixState,
    'is_completed': isCompleted,
  };
}
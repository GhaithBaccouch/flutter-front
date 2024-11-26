class Subject {
  final String? id;
  final String name;
  final String description;
  final double coefficient;
  final int numberOfHours;

  Subject({
    this.id,
    required this.name,
    required this.description,
    required this.coefficient,
    required this.numberOfHours,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      coefficient: json['coefficient'],
      numberOfHours: json['numberOfHours'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'coefficient': coefficient,
        'numberOfHours': numberOfHours,
      };
}

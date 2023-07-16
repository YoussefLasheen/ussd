class Code {
  final String name;
  final String code;

  Code({required this.name, required this.code});

  factory Code.fromJson(Map<String, dynamic> json) {
    return Code(
      name: json['name'],
      code: json['code'],
    );
  }
}

class CodeSection {
  final String name;
  final List<Code> codes;

  CodeSection({required this.name, required this.codes});

  factory CodeSection.fromJson(Map<String, dynamic> json) {
    return CodeSection(
      name: json['sectionName'],
      codes: List<Code>.from(json['codes'].map((x) => Code.fromJson(x))),
    );
  }
}
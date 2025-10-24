class Account {
    final String id;
    final String code;
    final String name;
    final String type;
    final String normalBalance;
    final DateTime createdAt;
    final DateTime updatedAt;

    Account({
        required this.id,
        required this.code,
        required this.name,
        required this.type,
        required this.normalBalance,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Account.fromJson(Map<String, dynamic> json) {
        return Account(
            id: json['id'],
            code: json['code'],
            name: json['name'],
            type: json['type'],
            normalBalance: json['normalBalance'],
            createdAt: DateTime.parse(json['createdAt']),
            updatedAt: DateTime.parse(json['updatedAt']),
        );
    }
}

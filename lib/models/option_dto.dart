class OptionDTO {
  final int id;
  final String name;
  final int price;
  final String type;
  final bool? required;
  final int storeId;

  OptionDTO({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
    this.required,
    required this.storeId,
  });

  factory OptionDTO.fromJson(Map<String, dynamic> json) {
    return OptionDTO(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      type: json['type'],
      required: json['required'],
      storeId: json['storeId'],
    );
  }
}
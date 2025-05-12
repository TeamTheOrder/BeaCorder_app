class OptionDTO {
  final int id;
  final String name;
  final int price;
  final bool required;
  final int storeId;

  OptionDTO({
    required this.id,
    required this.name,
    required this.price,
    required this.required,
    required this.storeId,
  });

  factory OptionDTO.fromJson(Map<String, dynamic> json) {
    return OptionDTO(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      required: json['required'],
      storeId: json['storeId'],
    );
  }
}
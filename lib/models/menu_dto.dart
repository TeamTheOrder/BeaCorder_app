class MenuDTO {
  final int id;
  final String name;
  final int price;

  MenuDTO({
    required this.id,
    required this.name,
    required this.price,
  });

  factory MenuDTO.fromJson(Map<String, dynamic> json) {
    return MenuDTO(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }
}

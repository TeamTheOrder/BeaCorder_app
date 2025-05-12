import 'option_dto.dart';

class MenuDTO {
  final int id;
  final String name;
  final int price;
  final String menuImg;
  final String? description;
  final List<OptionDTO> oList;
  final int storeId;

  MenuDTO({
    required this.id,
    required this.name,
    required this.price,
    required this.menuImg,
    this.description,
    required this.oList,
    required this.storeId,
  });

  factory MenuDTO.fromJson(Map<String, dynamic> json) {
    return MenuDTO(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      menuImg: json['menuImg'],
      description: json['description'] ?? '메뉴 소개',
      oList: (json['o_list'] as List).map((i) => OptionDTO.fromJson(i)).toList(),
      storeId: json['store_id'],
    );
  }
}
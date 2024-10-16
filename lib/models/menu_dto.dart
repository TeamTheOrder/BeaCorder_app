class MenuDTO {
  final int id;
  final String name;
  final int price;
  final String menuImg;
  final List<Map<String, dynamic>> oList; // 옵션 리스트 필드 추가

  MenuDTO({
    required this.id,
    required this.name,
    required this.price,
    required this.menuImg,
    required this.oList
  });

  factory MenuDTO.fromJson(Map<String, dynamic> json) {
    return MenuDTO(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      menuImg: json['menuImg'],
      // oList 필드를 JSON 배열에서 변환하여 처리
      oList: List<Map<String, dynamic>>.from(json['o_list'] ?? []), // JSON 배열을 List<Map<String, dynamic>>로 변환
    );
  }
}

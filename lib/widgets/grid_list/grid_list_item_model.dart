class GridListItemModel<T> {
  final String image;
  final String id;
  final String title;
  final String? description;
  final T data;

  GridListItemModel({
    required this.image,
    required this.id,
    required this.title,
    this.description,
    required this.data,
  });

  GridListItemModel<T> copyWith({
    String? image,
    String? id,
    String? title,
    String? description,
    T? data,
  }) {
    return GridListItemModel<T>(
      image: image ?? this.image,
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      data: data ?? this.data,
    );
  }
}

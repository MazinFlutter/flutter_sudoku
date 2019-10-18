


class BoardNumbers {
  bool response;
  String size;
  List<Squares> squares;

  BoardNumbers({this.response, this.size, this.squares});

  BoardNumbers.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    size = json['size'];
    if (json['squares'] != null) {
      squares = new List<Squares>();
      json['squares'].forEach((v) {
        squares.add(new Squares.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    data['size'] = this.size;
    if (this.squares != null) {
      data['squares'] = this.squares.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Squares {
  int x;
  int y;
  int value;

  Squares({this.x, this.y, this.value});

  Squares.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    data['value'] = this.value;
    return data;
  }
}
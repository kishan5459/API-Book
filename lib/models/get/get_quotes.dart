class QuotesResponse {
  int? statusCode;
  Quotes? data;
  String? message;
  bool? success;

  QuotesResponse({this.statusCode, this.data, this.message, this.success});

  QuotesResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? Quotes.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['success'] = success;
    return data;
  }
}

class Quotes {
  int? page;
  int? limit;
  int? totalPages;
  bool? previousPage;
  bool? nextPage;
  int? totalItems;
  int? currentPageItems;
  List<Quote>? data;

  Quotes({
    this.page,
    this.limit,
    this.totalPages,
    this.previousPage,
    this.nextPage,
    this.totalItems,
    this.currentPageItems,
    this.data,
  });

  Quotes.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    previousPage = json['previousPage'];
    nextPage = json['nextPage'];
    totalItems = json['totalItems'];
    currentPageItems = json['currentPageItems'];
    if (json['data'] != null) {
      data = <Quote>[];
      json['data'].forEach((v) {
        data!.add(Quote.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['previousPage'] = previousPage;
    data['nextPage'] = nextPage;
    data['totalItems'] = totalItems;
    data['currentPageItems'] = currentPageItems;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Quote {
  String? author;
  String? content;
  List<String>? tags;
  String? authorSlug;
  int? length;
  String? dateAdded;
  String? dateModified;
  int? id;

  Quote({
    this.author,
    this.content,
    this.tags,
    this.authorSlug,
    this.length,
    this.dateAdded,
    this.dateModified,
    this.id,
  });

  Quote.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    content = json['content'];
    tags = json['tags'].cast<String>();
    authorSlug = json['authorSlug'];
    length = json['length'];
    dateAdded = json['dateAdded'];
    dateModified = json['dateModified'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['author'] = author;
    data['content'] = content;
    data['tags'] = tags;
    data['authorSlug'] = authorSlug;
    data['length'] = length;
    data['dateAdded'] = dateAdded;
    data['dateModified'] = dateModified;
    data['id'] = id;
    return data;
  }
}

enum BookType {
  book,
  audiobook,
  ebook;

  static BookType valueOf(String? value) {
    if (value == null) {
      return book;
    }
    return BookType.values.firstWhere(
      (element) => element.name == value,
      orElse: () => BookType.book,
    );
  }
}

enum BookCheckouts {
  purchased,
  trial,
  expired;

  static BookCheckouts? valueOf(String? value) {
    if (value == null) {
      return null;
    }
    return BookCheckouts.values.firstWhere(
      (element) => element.name == value,
    );
  }
}

enum DownloadQuality { low, medium, high }

enum LibraryStatus { active, inactive }

enum BookStatus { active, inactive }

enum BookContentRating {
  allAges, // Suitable for everyone
  children, // Ages ~6-12
  youngAdult, // Ages ~12-17
  teen, // Ages ~13+
  mature, // Ages ~16-18+
  adult, // Explicit content, 18+ only
  unrated, // Not yet rated / unknown
}

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

class BannerImg {
  // ignore: non_constant_identifier_names
  final String banner_image;
  final String banner_link;

  BannerImg({this.banner_image, this.banner_link});

  factory BannerImg.fromJson(Map<String, dynamic> json) {
    return BannerImg(
        banner_link: json['banner_link'],
        banner_image: json['banner_image'],
    );
  }

}
import 'package:project_x/poi/poi.dart';

List<Poi> mockPoiList = [
  Poi(
    id: "poi1",
    name: "Public Bathroom",
    type: "toilets",
    description: "Free to use, in UA catacumbas.",
    latitude: 40.63071,
    longitude: -8.65875,
    pictureUrl:
        "https://www.jpn.up.pt/wp-content/uploads/2018/02/wc_p%C3%BAblica_3_06-de-fevereiro-de-2018.jpg",
    ratingPositive: 2,
    ratingNegative: 1,
    addedBy: "user1",
  ),
  Poi(
    id: "poi2",
    name: "Bycicle Parking",
    type: "bicycle-parking",
    description: "Old yellow racks that require a lock.",
    latitude: 40.63438,
    longitude: -8.65754,
    pictureUrl:
        "https://stplattaprod.blob.core.windows.net/liikenneprod/styles/og_image/azure/pyorapysakointi-jenni-huovinen.jpg?h=c176692e&itok=4KvwzNO_",
    ratingPositive: 3,
    ratingNegative: 1,
    addedBy: "user2",
  )
];

Poi mockPoi(int i, double latitude, double longitude) => Poi(
      id: "poi$i",
      name: "poi$i name",
      type: "poi$i type",
      description: "poi$i description",
      latitude: latitude,
      longitude: longitude,
      pictureUrl:
          "https://www.jpn.up.pt/wp-content/uploads/2018/02/wc_p%C3%BAblica_3_06-de-fevereiro-de-2018.jpg",
      ratingPositive: 0,
      ratingNegative: 0,
      addedBy: "testUser",
    );

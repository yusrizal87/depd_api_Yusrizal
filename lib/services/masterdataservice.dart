part of 'services.dart';

class MasterDataService {
  static Future<List<Province>> getProvince() async {
    var response = await http.get(
      Uri.https(Const.baseUrl, "/starter/province"),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'key': Const.apiKey
      },
    );
    var job = json.decode(response.body);
    print(job.toString());
    List<Province> result = [];

    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => Province.fromJson(e))
          .toList();
      return result;
    } else {
      throw 'Failed to load data';
    }
  }
  static Future<List<City>> getCity(var provid) async {
    var response = await http.get(
      Uri.https(Const.baseUrl, "/starter/city"),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'key': Const.apiKey
      },
    );
    var job = json.decode(response.body);
    print(job.toString());
    List<City> result = [];

    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => City.fromJson(e))
          .toList();
      
    } else {
      throw 'Failed to load data';
    }
    List<City> simpankota = [];
    for (var c in result){
      if (c.provinceId == provid){
        simpankota.add(c);
      }
    }
    return simpankota;

  }
}

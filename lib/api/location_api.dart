import 'package:dio/dio.dart';


Future<void> getLocationFromApi(double  latitude,double longitude) async{
 
  final String endpoint = "https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${latitude}&longitude=${longitude}&localityLanguage=pt";
  var dio = Dio();
  try{
    print("entrei aqui");
    Response response = await dio.get(endpoint);
    print("passei response");

    print(response.data["city"]);
    print(response.data["isoName"]);
   
  }on DioError catch(e){
      print("cai no err");
      print(e);
  }
}


import 'package:sembast/sembast.dart';
import 'package:variedadesjm/controllers/database/sembast_abstract_dao.dart';
import 'package:variedadesjm/modules/marca/entity/marca.dart';
import 'package:variedadesjm/controllers/database/sembast_stores.dart';


class MarcaDAO extends SembastDao<Marca>{
  MarcaDAO(Database database) : super(database, SembastStores.marca );

  @override
  Marca fromJson(Map<String, dynamic> json){
    return Marca.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Marca item){
    return item.toJson();
  }

}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sembast/sembast_io.dart'; 
import 'package:path/path.dart';                 
import 'package:path_provider/path_provider.dart'; 


final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final sembastDatabaseProvider = FutureProvider<Database>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final dbPath = join(dir.path, 'variedadesjm.db');
  
  final db = await databaseFactoryIo.openDatabase(dbPath);
  
  ref.onDispose(() async {
    await db.close();
  });
  
  return db;
});


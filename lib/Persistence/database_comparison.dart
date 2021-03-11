import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traze/Persistence/database.dart';
import 'package:traze/Persistence/database_cloud.dart';

class DatabaseComparison{

  // making it a singleton class
  DatabaseComparison._privateConstructor();
  static final DatabaseComparison instance = DatabaseComparison._privateConstructor();

  // method for check for match with positive uuids
  Future<bool> isAPositiveUuid(String uuid) async {
    List<QueryDocumentSnapshot> results =  await FirestoreDatabaseService.instance.queryPositiveUuid(uuid);
    if (results.length == 0)
      return false;
    else
      return true;
  }

  Future<bool> foundMatch() async {
    List<String> duplicates = await ProximityDatabaseProvider.instance.queryDuplicateEncounters();
    for(var uuid in duplicates){
      bool isPositive = await isAPositiveUuid(uuid);
      if(isPositive) {
        print('matching uuid found: $uuid');
        print('possible exposure to covid');
        return true;
      }
    }
    print('no possible exposure to covid detected');
    return false;
  }

}


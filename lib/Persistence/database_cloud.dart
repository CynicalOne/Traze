import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traze/Persistence/database.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreDatabaseService {

  // collection reference
  final CollectionReference positiveUuidCollection = Firestore.instance.collection('positiveuuids');

  // making it a singleton class
  FirestoreDatabaseService._privateConstructor();
  static final FirestoreDatabaseService instance = FirestoreDatabaseService._privateConstructor();

  Future addRecord(String uuid) async {
    return await positiveUuidCollection.add({
      'uuid': uuid,
      'datetime_testedPositive': Timestamp.now(),
    });
  }

/*
  Query testingFirestoreQuery()  {
  return positiveUuidCollection.where('datetime_testedPositive', isLessThanOrEqualTo: Timestamp.now()-Timestamp.fromMillisecondsSinceEpoch(2592000000));
  }
*/

  Future addPositiveUuids() async {
    List<String> myRecentUuids = await ProximityDatabaseProvider.instance.queryMyRecentUuids();
    for (var i = 0; i < myRecentUuids.length; i++){
      addRecord(myRecentUuids[i]);
    }
  }





}
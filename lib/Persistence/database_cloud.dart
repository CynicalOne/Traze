import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traze/Persistence/database.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreDatabaseService {

  final CollectionReference positiveUuidCollection = Firestore.instance.collection('positiveuuids');

  // making it a singleton class
  FirestoreDatabaseService._privateConstructor();
  static final FirestoreDatabaseService instance = FirestoreDatabaseService._privateConstructor();

  Future addRecord(int _id, String uuid) async {
    return await positiveUuidCollection.add({
      'id': _id,
      'uuid': uuid,
      'datetime_testedPositive': Timestamp.now(),
    });
  }

    Future addPositiveUuids() async {
      List<int> myRecentUuids_id = await ProximityDatabaseProvider.instance.queryMyRecentUuids_id();
      List<String> myRecentUuids_uuid = await ProximityDatabaseProvider.instance.queryMyRecentUuids_uuid();
      for (var i = 0; i < myRecentUuids_id.length; i++){
        addRecord(myRecentUuids_id[i], myRecentUuids_uuid[i]);
      }
  }





}
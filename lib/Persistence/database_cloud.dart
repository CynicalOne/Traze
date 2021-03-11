import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traze/Persistence/database.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreDatabaseService {

  final CollectionReference positiveUuidCollection = Firestore.instance.collection('positiveuuids');

  // making it a singleton class
  FirestoreDatabaseService._privateConstructor();
  static final FirestoreDatabaseService instance = FirestoreDatabaseService._privateConstructor();

  Future addRecord(String uuid) async {
    return await positiveUuidCollection.add({
      'uuid': uuid,
      'datetime_reportedPositive': Timestamp.now(),
    });
  }

  deleteRecord(String doc_id) {
    positiveUuidCollection.doc(doc_id).delete();
  }

  // adds my recent uuids to the positive uuid cloud database
  Future addPositiveUuids() async {
    List<String> myRecentUuids = await ProximityDatabaseProvider.instance.queryMyRecentUuids();
    print('adding my recent uuids to myRecentUuids table:');
    for (var i = 0; i < myRecentUuids.length; i++){
      addRecord(myRecentUuids[i]);
      print(myRecentUuids[i]);
    }
  }

  // deletes old uuids from the positive uuid cloud database when user no longer contagious
  Future deleteOldPositiveUuids() async {
    final QuerySnapshot snapshot =
    await positiveUuidCollection
        .where("datetime_reportedPositive", isLessThanOrEqualTo: DateTime.now().subtract(Duration(days:30)))
        .get();
    print('old uuid documents to be deleted from positive uuid database:');
    snapshot.docs.forEach((DocumentSnapshot doc){
      print(doc.data());
      deleteRecord(doc.id);
    });
    print('end of old uuid deletion');
  }

}
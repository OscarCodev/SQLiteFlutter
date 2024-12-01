import 'package:diary_app/DataBase/CRUD.dart';
import 'package:diary_app/DataBase/DBTable.dart';

class Diary extends CRUD{
  int id;
  String type;
  String enterCode;
  Diary({this.id,this.type="",this.enterCode=""}):super(DBTable.DIARY);

  // {} -> Diary()
  factory Diary.toObject(Map<dynamic,dynamic> data){
    return (data!=null)?Diary(
      id:data['id'],
      type: data['type'],
      enterCode: data['enterCode']
    ):Diary();
  }

  // Diary() -> {}
  Map<String,dynamic>toMap(){
    return {
      'id':this.id,
      'type':this.type,
      'enterCode':this.enterCode
    };
  }

  // [{},{},{}] -> [Diary(),Diary(),Diary()]
  getList(parsed){
    return (parsed as List).map((map)=>Diary.toObject(map)).toList();
  }

  // Inserta un mapa a la DB
  // {} -> DB
  save()async{
   this.id= await insert(this.toMap());
   return(this.id>0)?this:null;
  }

  // DB -> [[Diary(),Diary(),Diary()]]
  Future<List<Diary>>getDiaries()async{
   var result= await query("SELECT * FROM ${DBTable.DIARY}");
   return getList(result);
  }

  //Se introduce un codigo y devuelve un objeto Diary si se encuentra un resultado válido.
  checkEnterCode(String enterCode)async{
    var result=await query("SELECT * FROM ${DBTable.DIARY} WHERE id=? AND enterCode=? ",arguments: [this.id,enterCode]);
    return Diary.toObject(result[0]);
  }
}
import 'package:diary_app/DataBase/CRUD.dart';
import 'package:diary_app/DataBase/DBTable.dart';
import 'package:sqflite/sqflite.dart';

class Page extends CRUD{
  int id;
  String date;
  String title;
  String content;
  int diaryId;

  Page({this.id,this.date="",this.title="",this.content="",this.diaryId=0}):super(DBTable.PAGE);

  // A partir de un solo mapa devuelve un objeto Page 
  // {} -> Page()
  factory Page.toObject(Map<dynamic,dynamic> data){
    return (data!=null)?Page(
        id:data['id'],
        date: data['date'],
        title: data['title'],
      content: data['content'],
      diaryId: data['diaryId'],
    ):Page();
  }

  // Del objeto actual se va devolver su equivalente al tipo mapa  
  // Page() -> {}
  Map<String,dynamic>toMap(){
    return {
      'id':this.id,
      'date':this.date,
      'title':this.title,
      'content':this.content,
    'diaryId':this.diaryId,
    };
  }

  // Recibe una lista de mapas y la convierte a una lista de objetos Page  
  // [{}, {}, {}] -> [Page(), Page(), Page()]
  getList(parsed){
    return (parsed as List).map((map)=>Page.toObject(map)).toList();
  }
  
  // Recibe el id del Diary y devuelve una lista de objetos de tipo Page correspondiente a ese Diary
  // diaryId -> [Page(), Page(), Page() .....]
  Future<List<Page>>getPages(idDiary)async{
    var result=await query("SELECT * FROM ${DBTable.PAGE} WHERE diaryId=?",arguments: [idDiary]);
    return getList(result);
  }

  // Si el id ya existe entonces es una actualización, si el id es nulo entonces es una inserción 
  saveOrUpdate()async{
    this.id = (this.id != null) ? await update(this.toMap()) : await insert(this.toMap());
    return (id > 0) ? this : null;
  }

  // Insertar una lista de objetos Page de golpe
  // [Page(), Page(), Page()] -> DB
  insertPages(List<Page> pages)async{
    final db= await database;

    db.transaction((database)async{
      Batch batch= database.batch();
      for(Page page in pages){
        batch.insert(table, page.toMap());
      }
      var result=await batch.commit(continueOnError: true,noResult: true);
      print("resultado $result");
    });
  }

}
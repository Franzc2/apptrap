
import 'dart:math';
import 'dart:ui';
import 'dart:io';
import 'package:app/core/models/formacionModel.dart';
import 'package:app/ui/views/agregar_formacion_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/ui/views/agregar_exp_profesional_page.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/models/expProfesionalModel.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:app/ui/views/editar_exp_profesional_page.dart';
import 'package:app/ui/views/editar_formacion_page.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class CurriculumPage extends StatefulWidget {
  final User user;
  CurriculumPage({Key key, this.user}) : super(key: key);

  @override
  _CurriculumPageState createState() {
    return _CurriculumPageState();
  }
}

class _CurriculumPageState extends State<CurriculumPage> {

  String pathPDF = "";
  String _fileName;
  String _path;
  bool _loadingPath=false;
  bool _loadingViewImage=false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  Future<File> createFileOfPdfUrl(String urlDoc) async {
    final url = urlDoc;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }




  @override
  Widget build(BuildContext context) {
    final crudUser=Provider.of<crudModel>(context);
    final loginState=Provider.of<LoginState>(context);
    final infoUser=Provider.of<LoginState>(context).infoUser();
    final List<ExpProfesional> expProfUser=Provider.of<LoginState>(context).expProfUser();
    final List<Formacion> formacionUser=Provider.of<LoginState>(context).formacionUser();

    void abrirPdf(String url, String namePDF)async{
      File fl= await createFileOfPdfUrl(url);
      String pathpdf=fl.path;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>PDFScreen(pathpdf,namePDF))
      );
      loginState.cargarDatosUser(widget.user.id);
    }


    Future deletePdfFiresbaseStorage()async{
      setState(() {
        _loadingPath=true;
      });
//      StorageReference reference=FirebaseStorage.instance.ref().child(infoUser.urlDocumentCurriculum);
//      reference.delete().then((_)=> print("PDF eliminado"));

      await crudUser.updateUser(
          User(
              nombreCompleto: widget.user.nombreCompleto,
              numCI: widget.user.numCI,
              fechaNacimiento: widget.user.fechaNacimiento,
              ciudadRecidencia: widget.user.ciudadRecidencia,
              telefonoCelular: widget.user.telefonoCelular,
              correoElectronico: widget.user.correoElectronico,
              urlImagePerfil: widget.user.urlImagePerfil,
              habilidades: widget.user.habilidades,
              estadoCuenta: widget.user.estadoCuenta,
              urlDocumentCurriculum: "",
              idiomas: widget.user.idiomas,
              nameDocCurriculum: ""
          ),
          widget.user.id
      );
      await loginState.cargarDatosUser(widget.user.id);
      setState(() {
        _loadingPath=false;
      });
    }


    Future getPdfAndUpload()async{
      setState(() {
        _loadingPath=true;
      });
      var rng = new Random();
      String randomName="";
      for (var i = 0; i < 20; i++) {
        print(rng.nextInt(100));
        randomName += rng.nextInt(100).toString();
      }
      File file = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['pdf']);
      if(file!=null){
        String fileNameDoc=file.path.split('/').last;
        String fileName = '${randomName}.pdf';
        print(fileName);
        print('${file.readAsBytesSync()}');

        // SavePDF
        StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
        StorageUploadTask uploadTask = reference.putData(file.readAsBytesSync());
        String url = await (await uploadTask.onComplete).ref.getDownloadURL();
        print(url);

        //document File Upload
        await crudUser.updateUser(
            User(
                nombreCompleto: widget.user.nombreCompleto,
                numCI: widget.user.numCI,
                fechaNacimiento: widget.user.fechaNacimiento,
                ciudadRecidencia: widget.user.ciudadRecidencia,
                telefonoCelular: widget.user.telefonoCelular,
                correoElectronico: widget.user.correoElectronico,
                urlImagePerfil: widget.user.urlImagePerfil,
                habilidades: widget.user.habilidades,
                estadoCuenta: widget.user.estadoCuenta,
                urlDocumentCurriculum: url,
                idiomas: widget.user.idiomas,
                nameDocCurriculum: fileNameDoc
            ),
            widget.user.id
        );
        await loginState.cargarDatosUser(widget.user.id);
      }
      setState(() {
        _loadingPath=false;
      });
    }



    // TODO: implement build
    return Scaffold(
      appBar:
      AppBar(
        title: Text("Curriculum",),
        backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
      ),

      body: Container(
        color: Color.fromRGBO(189, 189, 189, 0.15),
        child: ListView(
          padding: EdgeInsets.only( bottom: 15.0, top: 10.0, left: 10.0, right: 10.0,),
          children: <Widget>[
            // card imagen y nombre----------------------------------------------------------------------
            Card(
              child:Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      child: CircleAvatar(
                        radius: 45.0,
                        child: ClipOval( child: Image.network(infoUser.urlImagePerfil,width: 80,height: 80,fit: BoxFit.cover,),
                        ),
                      ),
                      padding: EdgeInsets.all(10.0),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text(infoUser.nombreCompleto,
                        style: TextStyle(fontSize: 18,color: Colors.black54,fontWeight: FontWeight.bold),),
                    ),
                    padding: EdgeInsets.only(bottom: 15),
                  )
                ],
              ),
            ),
            //card Experiencia Laboral-------------------------------------------------------------------
            Card(
              child:Column(
                children: <Widget>[
                  tituloCard("Experiencia profesional"),
                  buildExpercienciasProfesionales(context,expProfUser),
                  SizedBox( height: 5.0, ),
                  Center(
                    child: FlatButton.icon(
                      label: Text("Agregar experiencia profesional",style: TextStyle(color: Colors.indigo),),
                      icon: Icon(Icons.add,color: Colors.indigo,),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>AgregarExpProfesionalPage(user: widget.user,)));
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
              elevation: 3,
            ),
            //card Formacion-----------------------------------------------------------------------------
            Card(
              child:Column(
                children: <Widget>[
                  tituloCard("Formación"),
                  buildFormaciones(context, formacionUser),
                  SizedBox( height: 5.0,),
                  Center(
                    child: FlatButton.icon(
                      label: Text("Agregar formación",style: TextStyle(color: Colors.indigo),),
                      icon: Icon(Icons.add,color: Colors.indigo,),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>AgregarFormacionPage(user: widget.user,)));
                      },
                    ),
                  ),
                  SizedBox(height: 10.0,),
                ],
              ),elevation: 3,
            ),
            //card Curriculum adjunto--------------------------------------------------------------------
            Card(
              child:Column(
                children: <Widget>[
                  tituloCard("Curriculum adjunto"),
                  SizedBox( height: 5.0,),

                  new Builder(
                      builder:(BuildContext context){
                        if(_loadingPath==true){
                          return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: const CircularProgressIndicator());
                        }
                        else{
                          if(infoUser.nameDocCurriculum==""){
                            return OutlineButton.icon(
                              label: Text("Subir curriculum",style: TextStyle(color: Colors.indigo),),
                              icon: Icon(Icons.add,color: Colors.indigo,),
                              onPressed: (){
                                getPdfAndUpload();
                              },
                            );
                          }
                          else{
                            return Column(
                              children: <Widget>[
                                Card(
                                  child: ListTile(
                                    title: Text(infoUser.nameDocCurriculum),
                                    leading: Icon(Icons.attach_file),
                                    trailing: Icon(Icons.remove_red_eye, color: Colors.blue,),
                                    onTap: (){
                                      abrirPdf(infoUser.urlDocumentCurriculum, infoUser.nameDocCurriculum);
                                    },
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                        child:OutlineButton.icon(
                                            onPressed: (){
                                              getPdfAndUpload();
                                            },
                                            icon: Icon(Icons.edit, color: Colors.amber,),
                                            label: Text("Actualizar")
                                        )
                                    ),
                                    SizedBox(width: 8.0,),
                                    Flexible(
                                        child:OutlineButton.icon(
                                            onPressed: (){
                                              deletePdfFiresbaseStorage();
                                            },
                                            icon: Icon(Icons.delete, color: Colors.red),
                                            label: Text("Eliminar")
                                        )
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                )
                              ],
                            );
                          }

                        }
                      }
                  ),

                  SizedBox(height: 10.0,),
                ],
              ),
              elevation: 3,
            ),
          ],
        ),
      ),
    );

  }
  
  
  
  
  
  
  
  
  
  
  Widget tituloCard(String titulo){
    return Container(
      child:Row(
        children: <Widget>[
          Text(titulo,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
        ],
      ),
      padding: EdgeInsets.only(
          top:8.0,
          left:10.0
      ),
    );
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  Widget buildCardExpProf(BuildContext context,ExpProfesional expProfesional){
    return Card(
      child: ListTile(
        title: Text(
          expProfesional.cargo+' - '+expProfesional.empresa,
          style: TextStyle(fontSize: 15.5),),
        subtitle: Text(
            expProfesional.fechaInicio.toDate().year.toString()+' - '+expProfesional.fechaFin.toDate().year.toString()
        ),
        trailing:
          Icon(Icons.edit,color: Colors.amber,),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>EditarExpProfesionalPage(user: widget.user,expProfUser: expProfesional,)));
        },
      ),
    );
  }
  Widget buildCardFormacion(BuildContext context,Formacion formacion){
    return Card(
      child: ListTile(
        title: Text(
          formacion.nivelEstudios+' - '+formacion.institucion,
          style: TextStyle(fontSize: 15.5),),
        subtitle: Text(
            formacion.fechaInicio.toDate().year.toString()+' - '+formacion.fechaFin.toDate().year.toString()
        ),
        trailing:
        Icon(Icons.edit,color: Colors.amber,),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>EditarFormacionPage(user: widget.user,formacion: formacion,)));
        },
      ),
    );
  }
  Widget buildExpercienciasProfesionales(BuildContext context, List<ExpProfesional> expProfUser){
    print(expProfUser.length);
    if(expProfUser.length==0){
      return Container(
        child:
        Center(
          child: Text("Aún no tienes experiencias, ¡añadelas!",style: TextStyle(color: Colors.black54),),
        ),
        padding: EdgeInsets.all(15),
      );
    }else{
      return Column(
        children: expProfUser.map((experiencia)=> buildCardExpProf(context,experiencia)).toList(),
        mainAxisSize: MainAxisSize.max,
        verticalDirection: VerticalDirection.up,
      );
    }
  }
  Widget buildFormaciones(BuildContext context, List<Formacion> formacionesUser){
    print(formacionesUser.length);
    if(formacionesUser.length == 0 ){
      return Container(
        child:
        Center(
          child: Text("Aún no tienes experiencias, ¡añadelas!",style: TextStyle(color: Colors.black54),),
        ),
        padding: EdgeInsets.all(15),
      );

    }else{
      return Column(
        children: formacionesUser.map((formacion)=> buildCardFormacion(context,formacion)).toList(),
        mainAxisSize: MainAxisSize.max,
        verticalDirection: VerticalDirection.up,
      );
    }
  }

}



class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  String namePDF="";
  PDFScreen(this.pathPDF,this.namePDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text(namePDF),
          backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
//          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.share),
//              onPressed: () {},
//            ),
//          ],
        ),
        path: pathPDF);
  }
}
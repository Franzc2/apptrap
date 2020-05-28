import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;


class InfoParaDestacarPublicacionPage extends StatefulWidget {
  @override
  _InfoParaDestacarPublicacionPageState createState() => _InfoParaDestacarPublicacionPageState();
}

class _InfoParaDestacarPublicacionPageState extends State<InfoParaDestacarPublicacionPage> {
  File _imagePublicacion;
  String _uploadedFileURLPublicacion;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color.fromRGBO(63, 81, 181, 1.0),
        title: Text('Destacar publicación'),
      ),
      body: 
      
     ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Agregar una imagen de tu publicación.",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 16.0),textAlign: TextAlign.center,),
              ),
            ),
            Center(
              child: Text("Vista previa"),
            ),
            _imagePublicacion != null
                ?
//            Center(
//              child: Container(
//                child: Card(
//                  child: Stack(
//                    children: <Widget>[
//                      Positioned.fill(
//                          child: Image.asset(_imagePublicacion.path,fit: BoxFit.cover,)
//                      ),
//                      Positioned(
//                        bottom: 0.0,
//                        left: 0.0,
//                        right: 0.0,
//                        child:
//                        Container(
//                          child: Center(
//                            child: Text("Programacion y tecnologia",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,maxLines: 2,),
//                          ),
//                          height: 40,
//                          color: Colors.black54,
//                        ),
//                      )
//                    ],
//                  ),
//                  clipBehavior: Clip.antiAlias,
//                ),
//                height: 150,
//                width: 150,
//              ),
//            )
            Image.asset(
              _imagePublicacion.path,
              height: 150,
              )
                : Container(
                height: 150,
              child: Center(
                child: Container(
                  child: Card(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.image,color: Colors.black12,size: 50,),
                          SizedBox(height: 5,),
//                          Text("Vista previa",style: TextStyle(fontSize: 12.0,color: Colors.black54),)
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                  ),
                  height: 150,
                  width: 150,
                ),
              )
            ),
            _imagePublicacion == null
                ? RaisedButton(
              child: Text('Choose File'),
              onPressed: (){
                 chooseFileGaleria(_imagePublicacion);
              },
              color: Colors.cyan,
            )
                : Container(),
            _imagePublicacion != null
                ? RaisedButton(
              child: Text('Upload File'),
              onPressed: (){
                uploadFile(_imagePublicacion,_uploadedFileURLPublicacion);
              },
              color: Colors.cyan,
            )
                : Container(),
            _imagePublicacion != null
                ? RaisedButton(
              child: Text('Clear Selection'),
              onPressed: (){
                clearSelection(_imagePublicacion,_uploadedFileURLPublicacion);
              },
            )
                : Container(),
            Text('Uploaded Image'),
            _uploadedFileURLPublicacion != null
                ? Image.network(
              _uploadedFileURLPublicacion,
              height: 150,
            )
                : Container(),
          ],
        ),
    );
  }

   chooseFileGaleria(File _image) async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }
  Future chooseFileCamara(File _image) async {
    await ImagePicker.pickImage(source: ImageSource.camera).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile(File _image,String _uploadedFileURL) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('publicaciones/${Path.basename(_image.path)}}');
//            .child(Path.basename(_image.path));
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  void clearSelection(File _image,String _uploadedFileURL) {
    setState(() {
      _image = null;
      _uploadedFileURL = null;
    });
  }

}

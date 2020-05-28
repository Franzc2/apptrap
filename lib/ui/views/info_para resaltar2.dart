import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbols.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as Path;


class InfoParaDestacarPublicacionPage1 extends StatefulWidget {
  InfoParaDestacarPublicacionPage1({Key key}) : super(key: key);


  @override
  _InfoParaDestacarPublicacionPage1State createState() => _InfoParaDestacarPublicacionPage1State();
}

class _InfoParaDestacarPublicacionPage1State extends State<InfoParaDestacarPublicacionPage1> {
  File _imageFilePublicacion;
  File _imageFileDeposito;

  String _uploadedFileURLPublicacion;
  String _uploadedFileURLDeposito;

  dynamic _pickImageError;
  String _retrieveDataError;

  void _onImagePublicacionButtonPressed(ImageSource source1, {BuildContext context}) async {
    try {
      _imageFilePublicacion = await ImagePicker.pickImage(
        source: source1,
      );
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }

  void _onImageDepositoButtonPressed(ImageSource source2, {BuildContext context}) async {
    try {
      _imageFileDeposito = await ImagePicker.pickImage(
        source: source2,
      );
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }


  @override
  void dispose() {
    super.dispose();
  }


  Widget _previewImagePublicacion() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFilePublicacion != null) {
      return cardVistaPreviaConImagen(_imageFilePublicacion);
//        Image.file(_imageFile);
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return cardVistaPreviaSinImagen();
    }
  }

  Widget _previewImageDeposito() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileDeposito != null) {
      return cardDepositoConImagen(_imageFileDeposito);
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return cardDepositoSinImagen();
    }
  }

  Future<void> retrieveLostData(File imagenFile) async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {

      setState(() {
//        _imageFilePublicacion = response.file;
        imagenFile=response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color.fromRGBO(63, 81, 181, 1.0),
        title: Text("Destacar publicación"),
      ),
      body:
          ListView(
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
              Center(
                child: Platform.isAndroid
                    ? FutureBuilder<void>(
                  future: retrieveLostData(_imageFilePublicacion),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return
                          Container(
                            child: const Text(
                            'You have not yet picked an image 1.',
                            textAlign: TextAlign.center,
                            ),
                            height: 150,
                          );
                      case ConnectionState.done:
                        return  _previewImagePublicacion();
                      default:
                        if (snapshot.hasError) {
                          return Container(
                            child: Text(
                              'Pick image/video error: ${snapshot.error}}',
                              textAlign: TextAlign.center,
                            ),
                            height: 150,
                          );
                        } else {
                          return Container(
                            child: const Text(
                              'You have not yet picked an image 2.',
                              textAlign: TextAlign.center,
                            ),
                            height: 150,
                          );
                        }
                    }
                  },
                )
                    : (_previewImagePublicacion()),
              ),
              Center(
                child:
                Row(
                  children: <Widget>[
                    RaisedButton.icon(
                      label: Text("Galeria",style: TextStyle(color: Colors.white),),
                      icon: Icon(Icons.photo_library,color: Colors.white,),
                      color: Colors.blue,
                      onPressed: (){
                        _onImagePublicacionButtonPressed(ImageSource.gallery, context: context);
                      },
                    ),
                    SizedBox(width: 10.0,),
                    RaisedButton.icon(
                      label: Text("Camara",style: TextStyle(color: Colors.white),),
                      icon: Icon(Icons.camera_alt,color: Colors.white,),
                      color: Colors.blue,
                      onPressed: (){
                        _onImagePublicacionButtonPressed(ImageSource.camera, context: context);
                      },
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                )
              ),
              Divider(),
              Card(
                child: ListTile(
                  title: Text("El costo de esta opción es de 10 Bs."),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Agregar una foto del deposito de 10Bs al numero de cuenta: 1023412.",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 16.0),textAlign: TextAlign.center,),
                ),
              ),
              Center(
                child: Platform.isAndroid
                    ? FutureBuilder<void>(
                  future: retrieveLostData(_imageFileDeposito),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return
                          const Text(
                            'You have not yet picked an image 1.',
                            textAlign: TextAlign.center,
                          );
                      case ConnectionState.done:
                        return  _previewImageDeposito();
                      default:
                        if (snapshot.hasError) {
                          return Text(
                            'Pick image/video error: ${snapshot.error}}',
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return const Text(
                            'You have not yet picked an image 2.',
                            textAlign: TextAlign.center,
                          );
                        }
                    }
                  },
                )
                    : (_previewImageDeposito()),
              ),
              Center(
                  child:
                  Row(
                    children: <Widget>[
                      RaisedButton.icon(
                        label: Text("Galeria",style: TextStyle(color: Colors.white),),
                        icon: Icon(Icons.photo_library,color: Colors.white,),
                        color: Colors.blue,
                        onPressed: (){
                          _onImageDepositoButtonPressed(ImageSource.gallery, context: context);
                        },
                      ),
                      SizedBox(width: 10.0,),
                      RaisedButton.icon(
                        label: Text("Camara",style: TextStyle(color: Colors.white),),
                        icon: Icon(Icons.camera_alt,color: Colors.white,),
                        color: Colors.blue,
                        onPressed: (){
                          _onImageDepositoButtonPressed(ImageSource.camera, context: context);
                        },
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  )
              ),
              Divider(),
              _imageFilePublicacion==null && _imageFileDeposito==null? Container():Center(
                child: Container(
                  child: RaisedButton.icon(
                    color: Color.fromRGBO(63, 81, 181, 1),
                    onPressed: ()async{
                      uploadFileAndPopPage();
                    },
                    icon: Icon(Icons.file_upload,color: Colors.white,),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      child: Text("Enviar información",style: TextStyle(color: Colors.white,fontSize: 18),),
                    ),

                  ),
                  padding: EdgeInsets.all(10.0),
                ),
              ),

              SizedBox(height: 15.0,),
//              _uploadedFileURLPublicacion != null
//                  ? Image.network(
//                _uploadedFileURLPublicacion,
//                height: 150,
//              )
//                  : Container(),
            ],
          ),
    );
  }

  Widget cardVistaPreviaSinImagen(){
    return
        Center(
            child: Container(
              child: Card(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.image,color: Colors.black12,size: 50,),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              ),
              height: 150,
              width: 150,
            ),
          );
  }

  Widget cardDepositoSinImagen(){
    return
      Center(
        child: Container(
          child: Card(
            child: Center(
              child: Column(
                children: <Widget>[
                  Icon(Icons.image,color: Colors.black12,size: 50,),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ),
          height:200,
          width: 200,
        ),
      );
  }

  Widget cardVistaPreviaConImagen(File _imageFilePublicacion){
    return
    Center(
            child: Container(
              child: Card(
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.file(_imageFilePublicacion,fit: BoxFit.cover,)
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child:
                        Container(
                          child: Center(
                            child: Text("Programacion y tecnologia",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,maxLines: 2,),
                          ),
                          height: 40,
                          color: Colors.black54,
                        ),
                    )
                  ],
                ),
                clipBehavior: Clip.antiAlias,
              ),
              height: 150,
              width: 150,
            ),
          );
  }

  Widget cardDepositoConImagen(File _imageFileDeposito){
    return
      Center(
        child: Container(
          child: Card(
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                    child: Image.file(_imageFileDeposito,fit: BoxFit.cover,)
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
          ),
          height: 200,
          width: 200,
        ),
      );
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  uploadFileAndPopPage() async {

    StorageReference storageReference1 = FirebaseStorage.instance
        .ref()
          .child(Path.basename(_imageFilePublicacion.path));
    StorageUploadTask uploadTask1 = storageReference1.putFile(_imageFilePublicacion);
    await uploadTask1.onComplete;
    print('File Uploaded');

    storageReference1.getDownloadURL().then((fileURL) {
//      setState(() {
        _uploadedFileURLPublicacion = fileURL;
//      });
      print("url imagen publicacion"+ _uploadedFileURLPublicacion);
    });

    StorageReference storageReference2 = FirebaseStorage.instance
        .ref()
        .child(Path.basename(_imageFileDeposito.path));
    StorageUploadTask uploadTask2 = storageReference2.putFile(_imageFileDeposito);
    await uploadTask2.onComplete;
    storageReference2.getDownloadURL().then((fileURL) {
//      setState(() {
        _uploadedFileURLDeposito = fileURL;
//      });
      print("url imagen publicacion"+ _uploadedFileURLDeposito);


      List<String> arrayUrls=[_uploadedFileURLPublicacion,_uploadedFileURLDeposito];
      Navigator.pop(context, arrayUrls);
    });


  }

}
//
//typedef void OnPickImageCallback(
//    double maxWidth, double maxHeight, int quality);






















//
//import 'dart:io';
//
//import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:video_player/video_player.dart';
//
//
//class InfoParaDestacarPublicacionPage extends StatefulWidget {
//  InfoParaDestacarPublicacionPage({Key key}) : super(key: key);
//
//
//  @override
//  _InfoParaDestacarPublicacionPageState createState() => _InfoParaDestacarPublicacionPageState();
//}
//
//class _InfoParaDestacarPublicacionPageState extends State<InfoParaDestacarPublicacionPage> {
//  File _imageFile;
//  dynamic _pickImageError;
//  bool isVideo = false;
//  VideoPlayerController _controller;
//  String _retrieveDataError;
//
//  final TextEditingController maxWidthController = TextEditingController();
//  final TextEditingController maxHeightController = TextEditingController();
//  final TextEditingController qualityController = TextEditingController();
//
//  Future<void> _playVideo(File file) async {
//    if (file != null && mounted) {
//      await _disposeVideoController();
//      _controller = VideoPlayerController.file(file);
//      await _controller.setVolume(1.0);
//      await _controller.initialize();
//      await _controller.setLooping(true);
//      await _controller.play();
//      setState(() {});
//    }
//  }
//
//  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
//    if (_controller != null) {
//      await _controller.setVolume(0.0);
//    }
//    if (isVideo) {
//      final File file = await ImagePicker.pickVideo(
//          source: source, maxDuration: const Duration(seconds: 10));
//      await _playVideo(file);
//    } else {
//      await _displayPickImageDialog(context,
//              (double maxWidth, double maxHeight, int quality) async {
//            try {
//              _imageFile = await ImagePicker.pickImage(
//                  source: source,
//                  maxWidth: maxWidth,
//                  maxHeight: maxHeight,
//                  imageQuality: quality);
//              setState(() {});
//            } catch (e) {
//              _pickImageError = e;
//            }
//          });
//    }
//  }
//
//  @override
//  void deactivate() {
//    if (_controller != null) {
//      _controller.setVolume(0.0);
//      _controller.pause();
//    }
//    super.deactivate();
//  }
//
//  @override
//  void dispose() {
//    _disposeVideoController();
//    maxWidthController.dispose();
//    maxHeightController.dispose();
//    qualityController.dispose();
//    super.dispose();
//  }
//
//  Future<void> _disposeVideoController() async {
//    if (_controller != null) {
//      await _controller.dispose();
//      _controller = null;
//    }
//  }
//
//  Widget _previewVideo() {
//    final Text retrieveError = _getRetrieveErrorWidget();
//    if (retrieveError != null) {
//      return retrieveError;
//    }
//    if (_controller == null) {
//      return const Text(
//        'You have not yet picked a video',
//        textAlign: TextAlign.center,
//      );
//    }
//    return Padding(
//      padding: const EdgeInsets.all(10.0),
//      child: AspectRatioVideo(_controller),
//    );
//  }
//
//  Widget _previewImage() {
//    final Text retrieveError = _getRetrieveErrorWidget();
//    if (retrieveError != null) {
//      return retrieveError;
//    }
//    if (_imageFile != null) {
//      return Image.file(_imageFile);
//    } else if (_pickImageError != null) {
//      return Text(
//        'Pick image error: $_pickImageError',
//        textAlign: TextAlign.center,
//      );
//    } else {
//      return const Text(
//        'You have not yet picked an image.',
//        textAlign: TextAlign.center,
//      );
//    }
//  }
//
//  Future<void> retrieveLostData() async {
//    final LostDataResponse response = await ImagePicker.retrieveLostData();
//    if (response.isEmpty) {
//      return;
//    }
//    if (response.file != null) {
//      if (response.type == RetrieveType.video) {
//        isVideo = true;
//        await _playVideo(response.file);
//      } else {
//        isVideo = false;
//        setState(() {
//          _imageFile = response.file;
//        });
//      }
//    } else {
//      _retrieveDataError = response.exception.code;
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Destacar publicación"),
//      ),
//      body: Center(
//        child: Platform.isAndroid
//            ? FutureBuilder<void>(
//          future: retrieveLostData(),
//          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
//            switch (snapshot.connectionState) {
//              case ConnectionState.none:
//              case ConnectionState.waiting:
//                return const Text(
//                  'You have not yet picked an image.',
//                  textAlign: TextAlign.center,
//                );
//              case ConnectionState.done:
//                return isVideo ? _previewVideo() : _previewImage();
//              default:
//                if (snapshot.hasError) {
//                  return Text(
//                    'Pick image/video error: ${snapshot.error}}',
//                    textAlign: TextAlign.center,
//                  );
//                } else {
//                  return const Text(
//                    'You have not yet picked an image.',
//                    textAlign: TextAlign.center,
//                  );
//                }
//            }
//          },
//        )
//            : (isVideo ? _previewVideo() : _previewImage()),
//      ),
//      floatingActionButton: Column(
//        mainAxisAlignment: MainAxisAlignment.end,
//        children: <Widget>[
//          FloatingActionButton(
//            onPressed: () {
//              isVideo = false;
//              _onImageButtonPressed(ImageSource.gallery, context: context);
//            },
//            heroTag: 'image0',
//            tooltip: 'Pick Image from gallery',
//            child: const Icon(Icons.photo_library),
//          ),
//          Padding(
//            padding: const EdgeInsets.only(top: 16.0),
//            child: FloatingActionButton(
//              onPressed: () {
//                isVideo = false;
//                _onImageButtonPressed(ImageSource.camera, context: context);
//              },
//              heroTag: 'image1',
//              tooltip: 'Take a Photo',
//              child: const Icon(Icons.camera_alt),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  Text _getRetrieveErrorWidget() {
//    if (_retrieveDataError != null) {
//      final Text result = Text(_retrieveDataError);
//      _retrieveDataError = null;
//      return result;
//    }
//    return null;
//  }
//
//  Future<void> _displayPickImageDialog(
//      BuildContext context, OnPickImageCallback onPick) async {
//    return showDialog(
//        context: context,
//        builder: (context) {
//          return AlertDialog(
//            title: Text('Add optional parameters'),
//            content: Column(
//              children: <Widget>[
//                TextField(
//                  controller: maxWidthController,
//                  keyboardType: TextInputType.numberWithOptions(decimal: true),
//                  decoration:
//                  InputDecoration(hintText: "Enter maxWidth if desired"),
//                ),
//                TextField(
//                  controller: maxHeightController,
//                  keyboardType: TextInputType.numberWithOptions(decimal: true),
//                  decoration:
//                  InputDecoration(hintText: "Enter maxHeight if desired"),
//                ),
//                TextField(
//                  controller: qualityController,
//                  keyboardType: TextInputType.number,
//                  decoration:
//                  InputDecoration(hintText: "Enter quality if desired"),
//                ),
//              ],
//            ),
//            actions: <Widget>[
//              FlatButton(
//                child: const Text('CANCEL'),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              ),
//              FlatButton(
//                  child: const Text('PICK'),
//                  onPressed: () {
//                    double width = maxWidthController.text.isNotEmpty
//                        ? double.parse(maxWidthController.text)
//                        : null;
//                    double height = maxHeightController.text.isNotEmpty
//                        ? double.parse(maxHeightController.text)
//                        : null;
//                    int quality = qualityController.text.isNotEmpty
//                        ? int.parse(qualityController.text)
//                        : null;
//                    onPick(width, height, quality);
//                    Navigator.of(context).pop();
//                  }),
//            ],
//          );
//        });
//  }
//}
//
//typedef void OnPickImageCallback(
//    double maxWidth, double maxHeight, int quality);
//
//class AspectRatioVideo extends StatefulWidget {
//  AspectRatioVideo(this.controller);
//
//  final VideoPlayerController controller;
//
//  @override
//  AspectRatioVideoState createState() => AspectRatioVideoState();
//}
//
//class AspectRatioVideoState extends State<AspectRatioVideo> {
//  VideoPlayerController get controller => widget.controller;
//  bool initialized = false;
//
//  void _onVideoControllerUpdate() {
//    if (!mounted) {
//      return;
//    }
//    if (initialized != controller.value.initialized) {
//      initialized = controller.value.initialized;
//      setState(() {});
//    }
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    controller.addListener(_onVideoControllerUpdate);
//  }
//
//  @override
//  void dispose() {
//    controller.removeListener(_onVideoControllerUpdate);
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (initialized) {
//      return Center(
//        child: AspectRatio(
//          aspectRatio: controller.value?.aspectRatio,
//          child: VideoPlayer(controller),
//        ),
//      );
//    } else {
//      return Container();
//    }
//  }
//}
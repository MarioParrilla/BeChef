import 'dart:io';

import 'package:be_chef_proyect/models/models.dart';
import 'package:be_chef_proyect/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../services/services.dart';


class EditProfileScreen extends StatelessWidget {
  static String newUsername = '';
  static String newDescription = '';
  static String newUrlImg = '';
  static File? newImg = null;
  static DataProfileProvider? dataProfileProvider;

  const EditProfileScreen(
    {Key? key}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {

  dataProfileProvider = Provider.of<DataProfileProvider>(context, listen: true);
  final dataUserLoggedService = Provider.of<DataUserLoggedService>(context, listen: false);

  String oldUsername = dataProfileProvider!.username.isEmpty ? 'username' : dataProfileProvider!.username;
  String oldDescription = dataProfileProvider!.description.isEmpty ? 'description' : dataProfileProvider!.description;
  String oldUrlImg = dataProfileProvider!.urlImgTemp.isEmpty ? 'https://d500.epimg.net/cincodias/imagenes/2016/07/04/lifestyle/1467646262_522853_1467646344_noticia_normal.jpg' : dataProfileProvider!.urlImgTemp;

  Future<void> modifyUser() async {

    if(dataProfileProvider!.usernameChanged || dataProfileProvider!.descriptionChanged || dataProfileProvider!.urlImgChanged) {
      dynamic newUser = await dataUserLoggedService.changeBasicDataUser(context, newUsername, newDescription, newImg);
      
      if(newUser.runtimeType == User) {
        if(newImg == null){
          dataProfileProvider!.username = newUser.username == '' ? oldUsername : newUser.username;
          dataProfileProvider!.description = newUser.description == '' ? oldDescription : newUser.description;
        }else{
          dataProfileProvider!.username = newUser.username == '' ? oldUsername : newUser.username;
          dataProfileProvider!.description = newUser.description == '' ? oldDescription : newUser.description;
          dataProfileProvider!.urlImg = newUser.urlImg;
        }

        dataProfileProvider!.usernameChanged = false;
        dataProfileProvider!.descriptionChanged = false;
        dataProfileProvider!.urlImgChanged = false;

        Navigator.of(context).pop();
      }else{
        NotificationsService.showSnackBar(newUser['error']);
      }
    }else 
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _ImageOfCard(urlImg: oldUrlImg),
            _FormRecipe(username: oldUsername, description: oldDescription),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save_rounded),
        backgroundColor: Colors.deepOrange,
        onPressed: () => modifyUser(),
      )
    );
  }
}


class _ImageOfCard extends StatelessWidget {

  String urlImg;
  _ImageOfCard({Key? key, required this.urlImg}) : super(key: key);

  @override
  Widget build(BuildContext context) {

  final ImagePicker imagePicker = ImagePicker();
  PickedFile? pickedFile;

    takeGalleryImg() async {
      pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
      if(pickedFile != null) {
        EditProfileScreen.newImg = File(pickedFile!.path);  
        EditProfileScreen.dataProfileProvider!.urlImgTemp = pickedFile!.path;
        EditProfileScreen.newUrlImg = pickedFile!.path;
        urlImg = pickedFile!.path;
        EditProfileScreen.dataProfileProvider!.urlImgChanged = true;
        Navigator.of(context).pop();
      }
    }

    takeCameraImg() async {
      pickedFile = await imagePicker.getImage(source: ImageSource.camera);
      if(pickedFile != null) {
        EditProfileScreen.newImg = File(pickedFile!.path);  
        EditProfileScreen.dataProfileProvider!.urlImgTemp = pickedFile!.path;
        EditProfileScreen.newUrlImg = pickedFile!.path;
        urlImg = pickedFile!.path;
        EditProfileScreen.dataProfileProvider!.urlImgChanged = true;
        Navigator.of(context).pop();
      }
    }

    AlertDialog alert (BuildContext context){
      
      return AlertDialog(
        title: Text("¿Como quieres elegir la imagen?"),
        content: Container(
          height: 140,
          child: Column(
            children: [
              const Text("Elige el metodo para escoger la imagen"),
              TextButton(onPressed:() async => {
                takeCameraImg()
              }, child: const Text("Camara", style: TextStyle(color: Colors.deepOrange),)),
              
              TextButton(onPressed:() async => {
                takeGalleryImg()
              }, child: const Text("Galeria", style: TextStyle(color: Colors.deepOrange),)),
            ],
          ),
        ),
      );
    }

    ImageProvider getImage(String? img){
      if(img == null) {
        return  NetworkImage('https://d500.epimg.net/cincodias/imagenes/2016/07/04/lifestyle/1467646262_522853_1467646344_noticia_normal.jpg');
      }

      if(img.startsWith('http')) {
        return NetworkImage(img);
      }

      return FileImage(File(img));
    }

    return GestureDetector(
      onTap: () async {
        showDialog(context: context, builder: alert);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 250,
            width: double.infinity,
            child: Stack(
              children: [
                CircleAvatar(
                  maxRadius: 250,
                  backgroundImage: getImage(urlImg),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 150, left: 132),
                  child: const Icon(Icons.camera_alt, color: Color.fromARGB(110, 68, 68, 68), size: 80,),
                )
      
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormRecipe extends StatelessWidget {

  final String username;
  final String description;

  const _FormRecipe({Key? key, required this.username, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    usrChanged(String value){
      EditProfileScreen.newUsername = value;
      EditProfileScreen.dataProfileProvider!.usernameChanged = true;
    }

    dscChanged(String value){
      EditProfileScreen.newDescription = value;
      EditProfileScreen.dataProfileProvider!.descriptionChanged = true;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        child: Column(
          children: [
            CustomInputField(color: Colors.deepOrange, initialValue: username, labelText: 'Username', hintText: 'My Username', validator: ( String value ) => value.length > 3 && value.length < 16 ? null : 'Debe tener entre 4 y 15 caracteres', onChange: (String value) => usrChanged(value)),
            CustomInputField(color: Colors.deepOrange, minLines: 2, maxLines: 3,initialValue: description, labelText: 'Description', hintText: 'My Description',  validator: ( String value ) => value.length < 101 ? null : 'Debe tener menos de 100 caracteres' , onChange: (String value) => dscChanged(value)),
          ],
        )
      ),
    );
  }
}
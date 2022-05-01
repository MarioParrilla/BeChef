import 'package:be_chef_proyect/models/models.dart';
import 'package:be_chef_proyect/services/data_user_logged_service.dart';
import 'package:be_chef_proyect/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../services/services.dart';


class EditProfileScreen extends StatelessWidget {
  static String newUsername = '';
  static String newDescription = '';

  const EditProfileScreen(
    {Key? key}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {

  final dataProfileProvider = Provider.of<DataProfileProvider>(context, listen: false);
  final dataUserLoggedService = Provider.of<DataUserLoggedService>(context, listen: false);


  String oldUsername = dataProfileProvider.username.isEmpty ? 'username' : dataProfileProvider.username;
  String oldDescription = dataProfileProvider.description.isEmpty ? 'description' : dataProfileProvider.description;
  String oldUrlImg = dataProfileProvider.urlImg.isEmpty ? 'https://d500.epimg.net/cincodias/imagenes/2016/07/04/lifestyle/1467646262_522853_1467646344_noticia_normal.jpg' : dataProfileProvider.urlImg;
  newUsername = oldUsername;
  oldDescription = oldDescription;
  
  Future<void> modifyUser() async {

    if(newUsername != oldUsername || newDescription != oldDescription) {
      dynamic newUser = await dataUserLoggedService.changeBasicDataUser(context, newUsername, newDescription);

      if(newUser.runtimeType == User) {
        dataProfileProvider.username = newUser.username;
        dataProfileProvider.description = newUser.description;
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
            Stack(
              children: [
                _ImageOfCard(urlImg: oldUrlImg),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.16,
                  left: MediaQuery.of(context).size.width * 0.405,
                  child: const Icon(Icons.camera_alt, color: Color.fromARGB(110, 68, 68, 68), size: 80,),
                ),
              ],
            ),
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

  final String urlImg;

  const _ImageOfCard({Key? key, required this.urlImg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 250,
            width: double.infinity,
            child: CircleAvatar(
              maxRadius: 50,
              backgroundImage: NetworkImage(urlImg),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        child: Column(
          children: [
            CustomInputField(color: Colors.deepOrange, initialValue: username, labelText: 'Username', hintText: 'My Username', validator: ( String value ) => value.length > 3 && value.length < 16 ? null : 'Debe tener entre 4 y 15 caracteres', onChange: (String value) => EditProfileScreen.newUsername = value,),
            CustomInputField(color: Colors.deepOrange, minLines: 2, maxLines: 3,initialValue: description, labelText: 'Description', hintText: 'My Description',  validator: ( String value ) => value.length < 101 ? null : 'Debe tener menos de 100 caracteres' , onChange: (String value) => EditProfileScreen.newDescription = value,),
          ],
        )
      ),
    );
  }
}
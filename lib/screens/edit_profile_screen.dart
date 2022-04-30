import 'package:be_chef_proyect/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                const _ImageOfCard(),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.16,
                  left: MediaQuery.of(context).size.width * 0.405,
                  child: const Icon(Icons.camera_alt, color: Color.fromARGB(110, 68, 68, 68), size: 80,),
                ),
              ],
            ),
            const _FormRecipe(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save_rounded),
        backgroundColor: Colors.deepOrange,
        onPressed: () => {
          Navigator.of(context).pop()
        },
      )
    );
  }
}


class _ImageOfCard extends StatelessWidget {

  const _ImageOfCard({Key? key}) : super(key: key);

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
            child: const CircleAvatar(
              maxRadius: 50,
              backgroundImage: NetworkImage('https://d500.epimg.net/cincodias/imagenes/2016/07/04/lifestyle/1467646262_522853_1467646344_noticia_normal.jpg'),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormRecipe extends StatelessWidget {

  const _FormRecipe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        child: Column(
          children: [
            CustomInputField(color: Colors.deepOrange, labelText: 'Username', hintText: 'My Username', validator: (){}, onChange: (){},),
            CustomInputField(color: Colors.deepOrange, labelText: 'Description', hintText: 'My Description', validator: (){}, onChange: (){}, ),
          ],
        )
      ),
    );
  }
}
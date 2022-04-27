

import 'package:be_chef_proyect/services/profile_info_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_input_field.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Column(
        children: [

          _ProfileHeader(height: height),
          const SizedBox( height: 10),
          // ignore: dead_code
          true ? const Text('Tus Recetas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)) : const Text('Sus Recetas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox( height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: height * 0.535,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: const [
                  
                  SizedBox( height: 10),
                  _RecipeCard(urlImageRecipe: 'https://cdn.colombia.com/gastronomia/2011/08/25/macarrones-a-la-mediterranea-3327.jpg'),
                  SizedBox( height: 10),
                  
                  _RecipeCard(urlImageRecipe: 'https://static2.abc.es/media/bienestar/2021/09/27/tipos-de-carne-1-kWj--620x349@abc.jpg'),
                  SizedBox( height: 10),

                  _RecipeCard(urlImageRecipe: 'https://images.ecestaticos.com/lD5P5Laq4xFzLo3B9J02zB_GDng=/92x95:1837x1406/1200x899/filters:fill(white):format(jpg)/f.elconfidencial.com%2Foriginal%2F8d6%2Fb2c%2F174%2F8d6b2c1744497538097bdf0bd5dd2c5a.jpg'),
                  SizedBox( height: 10),

                ]
              )
            ),
          ),

        ],
      ),
      floatingActionButton: true
      ? FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
        onPressed: () => Navigator.of(context).pushNamed('recipe'),
      )
      // ignore: dead_code
      : null,
    );
  }
}

class _ProfileHeader extends StatelessWidget {

  final double height;

  const _ProfileHeader({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final profileInfoProvide = Provider.of<ProfileInfoService>(context, listen: false);

    AlertDialog alert = AlertDialog(
      title: Text("Editar Perfil"),
      content: Container(
        height: 120,
        child: Column(
          children: [
            CustomInputField(
              color: Colors.deepOrange, labelText: 'Username',
              hintText: 'username', icon: Icons.supervised_user_circle, isPassword: false,
              validator: ( String value ) => {}/*value.length > 4 ? null : 'Debe contener más de 4 caracteres'*/,
              onChange: ( String value ) => {/*loginForm.password = value*/},
            ),
            CustomInputField(
              color: Colors.deepOrange, labelText: 'Descripción',
              hintText: 'Descripción', icon: Icons.text_fields, isPassword: false,
              validator: ( String value ) => {}/*value.length > 4 ? null : 'Debe contener más de 4 caracteres'*/,
              onChange: ( String value ) => {/*loginForm.password = value*/},
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: Text("Editar", style: TextStyle(color: Colors.deepOrange)),
          onPressed: () => profileInfoProvide.test(),//Navigator.of(context).pop(),
        ),
      ],
    );

    return SizedBox(
            height: height * 0.2,
            //color: Colors.blueAccent,
            child: Row(
              children: [

                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20,),
                      child: const CircleAvatar(
                        maxRadius: 50,
                        backgroundImage: NetworkImage('https://d500.epimg.net/cincodias/imagenes/2016/07/04/lifestyle/1467646262_522853_1467646344_noticia_normal.jpg'),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 50,
                      child: GestureDetector(
                        onTap: () => {},
                        child: const Icon(Icons.edit, color: Color.fromRGBO(0, 0, 0, .3), size: 40,),
                      ),
                    ),
                  ]
                ),

                Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 30),
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('username', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            GestureDetector(
                              onTap: () => showDialog(
                                context: context,
                                builder: (c) => alert,
                              ),
                              child: Icon(Icons.edit, color: Color.fromRGBO(0, 0, 0, .3), size: 20,)
                            ),
                          ],
                        ),
                  ),
                    const SizedBox(
                      width: 150,
                      child: Text('Et veniam eiusmod reprehenderit officia Lorem commodo et adipisicing ipsum magna incididunt.', maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, ),
                    )),
                  ]
                ),

              ],
            ),
          );
  }
}


class _RecipeCard extends StatelessWidget {
  final String urlImageRecipe;
  
  const _RecipeCard({Key? key, required this.urlImageRecipe, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('recipe'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          height: 150,
          color: Colors.deepOrange,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                child: Container(
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/bechef_logo.png'), 
                    image: NetworkImage(urlImageRecipe),
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  )
              ),
            ),
      
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.white,
                  child: Column(
                    children: [
    
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        width: 180,
                        child: const Text('Recipe Name', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                      const SizedBox(
                        width: 180,
                        child: Text('Et veniam eiusmod reprehenderit officia Lorem commodo et adipisicing ipsum magna incididunt.', maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, ),
                      )),
    
                    ]
                  ),
                ),
            ),
      
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

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
        backgroundColor: Colors.deepOrange[300],
        onPressed: (){},
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
    return SizedBox(
            height: height * 0.2,
            //color: Colors.blueAccent,
            child: Row(
              children: [

                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20,),
                  child: const CircleAvatar(
                    maxRadius: 50,
                    backgroundImage: NetworkImage('https://d500.epimg.net/cincodias/imagenes/2016/07/04/lifestyle/1467646262_522853_1467646344_noticia_normal.jpg'),
                  ),
                ),
                Column(
                  children: [

                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      width: 150,
                      child: const Text('username', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                    const SizedBox(
                      width: 150,
                      child: Text('Et veniam eiusmod reprehenderit officia Lorem commodo et adipisicing ipsum magna incididunt.', maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, ),
                    )),

                  ]
                )
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: 200,
        color: Colors.deepOrange,
        child: Row(
          children: [
            
            FadeInImage(
              placeholder: const AssetImage('assets/bechef_logo.png'), 
              image: NetworkImage(urlImageRecipe),
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
    
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
    
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    width: 150,
                    child: const Text('Recipe Name', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                  const SizedBox(
                    width: 150,
                    child: Text('Et veniam eiusmod reprehenderit officia Lorem commodo et adipisicing ipsum magna incididunt.', maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, ),
                  )),
    
                ]
              ),
            ),
    
          ],
        ),
      ),
    );
  }
}
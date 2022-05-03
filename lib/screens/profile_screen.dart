

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
      
            _ProfileHeader(height: height),
            true ? 
                TextButton(
                  onPressed: () =>  Navigator.of(context).pushNamed('editProfile'),
                  child: Text('Editar Perfil'), 
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.deepOrange)
                      )))
                ) 
                : 
                const SizedBox( height: 48),
            const SizedBox( height: 5),
            // ignore: dead_code
            true ? const Text('Tus Recetas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)) : const Text('Sus Recetas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox( height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
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
          ],
        ),
      ),
      floatingActionButton: 
      true
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

    final dataProfileProvider = Provider.of<DataProfileProvider>(context, listen: true);
    String username = dataProfileProvider.username.isEmpty ? 'username' : dataProfileProvider.username;
    String description = dataProfileProvider.description.isEmpty ? 'description' : dataProfileProvider.description;
    String urlImg = dataProfileProvider.urlImg.isEmpty ? 'https://d500.epimg.net/cincodias/imagenes/2016/07/04/lifestyle/1467646262_522853_1467646344_noticia_normal.jpg' : dataProfileProvider.urlImg;

    return Container(
      padding: const EdgeInsets.only(top: 20),

      child: Row(
        children: [

          Container(
            margin: const EdgeInsets.only(left: 20, right: 20,),
            child: CircleAvatar(
              maxRadius: 50,
              backgroundImage: NetworkImage(urlImg),
            ),
          ),

          Column(
            children: [
              Container(
                  width: 150,
                  child: Text(username, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                width: 150,
                child: Text(description, maxLines: 5, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, ),
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
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('recipe'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            border: Border.all(color: Colors.black12, width: 1),

          ),
          padding: const EdgeInsets.only(right: 10),
          height: 150,
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
                  margin: const EdgeInsets.only(left: 10,),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: 150,
                  child: Column(
                    children: [
    
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text('Recipe Name', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                      const Flexible(
                        child: Text('Et veniam eiusmod reprehenderit officia Lorem commodo et adipisicing ipsum magna incididunt.', maxLines: 4,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, ),
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
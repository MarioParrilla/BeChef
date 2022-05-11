

import 'package:be_chef_proyect/models/models.dart';
import 'package:be_chef_proyect/services/recipe_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import 'screens.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipeService = Provider.of<RecipeService>(context, listen: true);

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

            FutureBuilder(
              future: recipeService.loadRecipesUserLogged(context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Recipe>? recipes = snapshot.data as List<Recipe>?;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: recipes!.length == 0 ? 1 : recipes.length,
                      itemBuilder: (context, index) {
                        if (recipes.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              SizedBox( height: 50),
                              Icon(Icons.no_food, color: Colors.deepOrange, size: 100),
                              Text('No hay recetas', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                            ],
                          );
                        }else{
                          return ListTile(
                            title: _RecipeCard(recipe: recipes[index]),
                          );
                        }
                      },
                    ),
                  );
                }
                else if(snapshot.hasError){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox( height: 50),
                      Icon(Icons.error_outline, color: Colors.deepOrange, size: 100),
                      Text('Se produjo un error', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  );
                }else{
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox( height: 50),
                      CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.deepOrange,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                      SizedBox( height: 10),
                      Text('Cargando recetas...', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  );
                }
              }
            )

          ],
        ),
      ),
      floatingActionButton: 
      true
      ? FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
        onPressed: () => Navigator.push(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => RecipeScreen(recipe: Recipe(), type: false),
      )),
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
  final Recipe recipe;

  
  const _RecipeCard({Key? key, 
    required this.recipe, 
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => Navigator.push(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => RecipeScreen(recipe: recipe, type: true),
      )),
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
                    image: NetworkImage(recipe.urlImg ?? 'https://static.thenounproject.com/png/380306-200.png'),
                    width: 100,
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
                        child: Text(recipe.name!, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, ),
                      )),
                      Flexible(
                        child: Text(recipe.description! , maxLines: 4,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, ),
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
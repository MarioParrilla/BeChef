import 'package:be_chef_proyect/models/models.dart';
import 'package:be_chef_proyect/services/recipe_service.dart';
import 'package:be_chef_proyect/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import 'screens.dart';

class ExternalProfile extends StatelessWidget {
  final int userID;

  const ExternalProfile({Key? key, required this.userID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipeService = Provider.of<RecipeService>(context, listen: true);
    final loggedUserRecipesProvider =
        Provider.of<LoggedUserRecipesProvider>(context, listen: true);

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _ProfileHeader(height: height, userID: userID),
            const SizedBox(height: 48),
            const SizedBox(height: 5),
            const Text('Sus Recetas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            FutureBuilder(
                future: recipeService.loadRecipesExternalUser(context, userID),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Recipe>? recipes = snapshot.data as List<Recipe>?;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: recipes!.isEmpty ? 1 : recipes.length,
                        itemBuilder: (context, index) {
                          if (recipes.isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(height: 50),
                                Icon(Icons.no_food,
                                    color: Colors.deepOrange, size: 100),
                                Text('No hay recetas',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold))
                              ],
                            );
                          } else {
                            return ListTile(
                              title: _RecipeCard(recipe: recipes[index]),
                            );
                          }
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(height: 50),
                        Icon(Icons.error_outline,
                            color: Colors.deepOrange, size: 100),
                        Text('Se produjo un error',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(height: 50),
                        CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.deepOrange,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                        SizedBox(height: 10),
                        Text('Cargando recetas...',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    );
                  }
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.close),
          backgroundColor: Colors.deepOrange,
          onPressed: () => Navigator.of(context).pop()),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final double height;
  final int userID;

  const _ProfileHeader({Key? key, required this.height, required this.userID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);

    return FutureBuilder(
        future: userService.findUserById(context, userID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User? user = snapshot.data as User?;
            return Container(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: CircleAvatar(
                      maxRadius: 50,
                      backgroundImage: NetworkImage(user!.urlImg!.isEmpty
                          ? 'https://d500.epimg.net/cincodias/imagenes/2016/07/04/lifestyle/1467646262_522853_1467646344_noticia_normal.jpg'
                          : user.urlImg!),
                    ),
                  ),
                  Column(children: [
                    Container(
                      width: 150,
                      child: Text(user.username ?? 'username',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                        width: 150,
                        child: Text(
                          user.description ?? 'description',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        )),
                  ]),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(height: 50),
                  Icon(Icons.error_outline,
                      color: Colors.deepOrange, size: 100),
                  Text('Se produjo un error',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(height: 50),
                  CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.deepOrange,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text('Cargando informacion del perfil...',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                ],
              ),
            );
          }
        });
  }
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const _RecipeCard({
    Key? key,
    required this.recipe,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    RecipeProvider recipeProvider =
        Provider.of<RecipeProvider>(context, listen: true);

    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => InfoRecipeScreen(recipe: recipe),
            )),
        recipeProvider.urlImg = recipe.urlImg!
      },
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
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                child: Container(
                    child: FadeInImage(
                  placeholder: const AssetImage('assets/bechef_logo.png'),
                  image: NetworkImage(recipe.urlImg ??
                      'https://static.thenounproject.com/png/380306-200.png'),
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                )),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: 150,
                  child: Column(children: [
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                          recipe.name!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Flexible(
                        child: Text(
                      recipe.description!,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    )),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

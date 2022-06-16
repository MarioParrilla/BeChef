import 'package:be_chef_proyect/models/models.dart';
import 'package:be_chef_proyect/services/recipe_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/providers.dart';
import 'screens.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipeService = Provider.of<RecipeService>(context, listen: true);
    final loggedUserRecipesProvider =
        Provider.of<LoggedUserRecipesProvider>(context, listen: true);

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _ProfileHeader(height: height),
            TextButton(
                onPressed: () => Navigator.of(context).pushNamed('editProfile'),
                child: const Text('Editar Perfil'),
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepOrange),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side:
                                const BorderSide(color: Colors.deepOrange))))),
            const SizedBox(height: 5),
            const Text('Tus Recetas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            FutureBuilder(
                future: recipeService.loadRecipesUserLogged(context),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Recipe>? recipes = loggedUserRecipesProvider.recipes;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: recipes.isEmpty ? 1 : recipes.length,
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
                    return Shimmer.fromColors(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black12, width: 1),
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
                                    width: 100,
                                    height: 150,
                                    color: Colors.white,
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 10,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    width: 150,
                                    child: Column(children: [
                                      Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: const Text(
                                            'Nombre',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                      const Flexible(
                                          child: Text(
                                        'Descripcion',
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
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
                        baseColor: Colors.white70,
                        highlightColor: Colors.grey.shade300);
                  }
                })
          ],
        ),
      ),
      floatingActionButton: true
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              backgroundColor: Colors.deepOrange,
              onPressed: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        RecipeScreen(recipe: Recipe(), type: false),
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
    final dataProfileProvider =
        Provider.of<DataProfileProvider>(context, listen: true);
    String username = dataProfileProvider.username.isEmpty
        ? 'username'
        : dataProfileProvider.username;
    String description = dataProfileProvider.description.isEmpty
        ? 'description'
        : dataProfileProvider.description;
    String urlImg = dataProfileProvider.urlImg.isEmpty
        ? 'https://d500.epimg.net/cincodias/imagenes/2016/07/04/lifestyle/1467646262_522853_1467646344_noticia_normal.jpg'
        : dataProfileProvider.urlImg;

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
              backgroundImage: NetworkImage(urlImg),
            ),
          ),
          Column(children: [
            Container(
              width: 150,
              child: Text(username,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
                width: 150,
                child: Text(
                  description,
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
    final recipeService = Provider.of<RecipeService>(context, listen: false);

    double width = MediaQuery.of(context).size.width;
    RecipeProvider recipeProvider =
        Provider.of<RecipeProvider>(context, listen: true);

    return FutureBuilder(
        future: recipeService.getRate(context, recipe.id!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () => {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          RecipeScreen(recipe: recipe, type: true),
                    )),
                recipeProvider.urlImg = recipe.urlImg ?? ''
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
                        child: Stack(
                          children: [
                            FadeInImage(
                              placeholder:
                                  const AssetImage('assets/bechef_logo.png'),
                              image: recipe.urlImg != null
                                  ? NetworkImage(recipe.urlImg!)
                                  : const NetworkImage(
                                      'https://static.thenounproject.com/png/380306-200.png'),
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  const Image(
                                image: NetworkImage(
                                    'https://static.thenounproject.com/png/380306-200.png'),
                                width: 100,
                                height: 150,
                              ),
                              width: 100,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    color: Colors.white,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          color: Colors.deepOrange,
                                        ),
                                        Text(
                                          snapshot.data!.toString(),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepOrange),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                          ],
                        ),
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
          } else if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 50),
                Icon(Icons.error_outline, color: Colors.deepOrange, size: 100),
                Text('Se produjo un error',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            );
          } else {
            return Shimmer.fromColors(
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
                            width: 100,
                            height: 150,
                            color: Colors.white,
                          ),
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
                                  child: const Text(
                                    'Nombre',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                              const Flexible(
                                  child: Text(
                                'Descripcion',
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
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
                baseColor: Colors.white70,
                highlightColor: Colors.grey.shade300);
          }
        });
  }
}

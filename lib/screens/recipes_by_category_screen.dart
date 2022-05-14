import 'package:be_chef_proyect/providers/list_category_provider.dart';
import 'package:be_chef_proyect/screens/recipe_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Recipe.dart';
import '../providers/providers.dart';
import '../services/recipe_service.dart';
import 'info_recipe_screen.dart';

class RecipesByCategoryPageScreen extends StatelessWidget {
  final String category;

  const RecipesByCategoryPageScreen(this.category, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecipeService recipeService = Provider.of<RecipeService>(context);
    ListCategoryProvider listCategoryProvider =
        Provider.of<ListCategoryProvider>(context, listen: true);

    final size = MediaQuery.of(context).size;
    final List<Recipe> recipes = listCategoryProvider.recipes;
    final ScrollController scrollController = ScrollController();

    Future fetchData(int lastID) async {
      if (listCategoryProvider.isLoading) return;

      listCategoryProvider.isLoading = true;

      listCategoryProvider.recipes.addAll(await recipeService
          .findRecipesByCategoryPaged(context, category, lastID));

      listCategoryProvider.isLoading = false;
    }

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 500) >=
          scrollController.position.maxScrollExtent) {
        fetchData(recipes.last.id!);
      }
    });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white12,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: recipeService.findRecipesByCategory(context, category),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Recipe>? recipes = snapshot.data as List<Recipe>?;
                return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: recipes!.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.no_food,
                                    color: Colors.deepOrange, size: 100),
                                Text('No hay recetas',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          )
                        : Stack(
                            children: [
                              ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                controller: scrollController,
                                itemCount: recipes.length,
                                itemBuilder: (context, index) {
                                  return _RecipeCard(
                                    recipe: recipes[index],
                                  );
                                },
                              ),
                              if (listCategoryProvider.isLoading)
                                Positioned(
                                    bottom: 40,
                                    left: (size.width / 2) - 30,
                                    child: const _LoadingIcon()),
                            ],
                          ));
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(height: 50),
                    CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.deepOrange,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                    SizedBox(height: 10),
                    Text('Cargando recetas...',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold))
                  ],
                );
              }
            }));
  }
}

class _LoadingIcon extends StatelessWidget {
  const _LoadingIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
      ),
      child: const CircularProgressIndicator(color: Colors.deepOrange),
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
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Flexible(
                        child: Text(
                      recipe.description!,
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
    );
  }
}

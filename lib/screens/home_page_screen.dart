import 'package:be_chef_proyect/screens/info_recipe_screen.dart';
import 'package:be_chef_proyect/screens/recipes_by_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../services/services.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryService = Provider.of<CategoryService>(context);
    final ScrollController scrollController = ScrollController();

    return FutureBuilder(
        future: categoryService.findCategories(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Category> categories = snapshot.data as List<Category>;
            return Container(
                color: const Color.fromRGBO(250, 250, 250, 1),
                child: categories.isNotEmpty
                    ? ListView.builder(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: categories.length,
                        itemBuilder: (context, index) => _HorizontalRecipes(
                            category: categories[index].name))
                    : Expanded(
                        child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.category_outlined,
                                color: Colors.deepOrange, size: 100),
                            Text('No hay categorias',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold))
                          ],
                        ),
                      )));
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 50),
                CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.deepOrange,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
                SizedBox(height: 10),
                Text('Cargando categorias...',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
              ],
            );
          }
        });
  }
}

class _HorizontalRecipes extends StatelessWidget {
  final String category;

  const _HorizontalRecipes({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final recipeService = Provider.of<RecipeService>(context, listen: false);
    return FutureBuilder(
        future: recipeService.findRecipesByCategory(context, category),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Recipe>? recipes = snapshot.data as List<Recipe>?;
            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: recipes!.isEmpty
                    ? ListTile(
                        title: Container(
                            width: double.infinity,
                            height: 170,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        children: [
                                          Text(
                                            category,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  left: 3, top: 3),
                                              child: const Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                  size: 15,
                                                  color: Colors.black)),
                                        ],
                                      )),
                                  const SizedBox(height: 5),
                                  Expanded(
                                      child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.no_food,
                                            color: Colors.deepOrange,
                                            size: 100),
                                        Text('No hay recetas',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  )),
                                ])),
                      )
                    : ListTile(
                        title: Container(
                            width: double.infinity,
                            height: 170,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: GestureDetector(
                                        onTap: () => {
                                          Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (_, __, ___) =>
                                                    RecipesByCategoryPageScreen(
                                                        category),
                                              )),
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              category,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    left: 3, top: 3),
                                                child: const Icon(
                                                    Icons
                                                        .arrow_forward_ios_outlined,
                                                    size: 15,
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      )),
                                  const SizedBox(height: 5),
                                  Expanded(
                                    child: ListView.builder(
                                        controller: scrollController,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: recipes.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) =>
                                            _RecipeCard(
                                              imgUrl: recipes[index].urlImg,
                                              recipe: recipes[index],
                                            )),
                                  ),
                                ])),
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
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
              ],
            );
          }
        });
  }
}

class _RecipeCard extends StatelessWidget {
  final String? imgUrl;
  final Recipe recipe;

  const _RecipeCard({Key? key, required this.imgUrl, required this.recipe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => InfoRecipeScreen(recipe: recipe),
            )),
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            child: FadeInImage(
              placeholder: const AssetImage('assets/bechef_logo.png'),
              image: imgUrl != null
                  ? NetworkImage(imgUrl!)
                  : const NetworkImage(
                      'https://static.thenounproject.com/png/380306-200.png'),
              imageErrorBuilder: (context, error, stackTrace) => const Image(
                  image: NetworkImage(
                      'https://static.thenounproject.com/png/380306-200.png')),
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:be_chef_proyect/providers/search_provider.dart';
import 'package:be_chef_proyect/screens/info_recipe_screen.dart';
import 'package:be_chef_proyect/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/providers.dart';
import '../services/recipe_service.dart';
import 'external_profile.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepOrange,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.fastfood)),
              Tab(icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            RecipeSearch(),
            UserSearch(),
          ],
        ),
      ),
    );
  }
}

class RecipeSearch extends StatelessWidget {
  const RecipeSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: true);
    List<Recipe> recipes = searchProvider.recipes;

    return Column(
      children: [
        const SizedBox(height: 10),
        CustomInputField(
          icon: Icons.search,
          color: Colors.deepOrange,
          validator: (v) {},
          onChange: (value) async {
            await searchProvider.getRecipesByQuery(value, context);
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: recipes.isEmpty ? 1 : recipes.length,
            itemBuilder: (_, index) {
              return recipes.isEmpty
                  ? Center(
                      child: Column(
                      children: const [
                        SizedBox(height: 50),
                        Icon(Icons.no_food,
                            color: Colors.deepOrange, size: 100),
                        Text('Busca una receta',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ))
                  : Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: _RecipeCard(recipe: recipes[index]),
                    );
            },
          ),
        ),
      ],
    );
  }
}

class UserSearch extends StatelessWidget {
  const UserSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: true);
    List<User> users = searchProvider.users;

    return Column(
      children: [
        const SizedBox(height: 10),
        CustomInputField(
          icon: Icons.search,
          color: Colors.deepOrange,
          validator: (v) {},
          onChange: (value) async {
            await searchProvider.getUsersByQuery(value, context);
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: users.isEmpty ? 1 : users.length,
            itemBuilder: (_, index) {
              return users.isEmpty
                  ? Center(
                      child: Column(
                      children: const [
                        SizedBox(height: 50),
                        Icon(Icons.person_off,
                            color: Colors.deepOrange, size: 100),
                        Text('Busca algun usuario',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ))
                  : Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: _UserCard(user: users[index]),
                    );
            },
          ),
        ),
      ],
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

    final recipeService = Provider.of<RecipeService>(context, listen: false);

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
                          InfoRecipeScreen(recipe: recipe),
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
                        child: Stack(children: [
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
                                        'https://static.thenounproject.com/png/380306-200.png')),
                            width: 150,
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                        ]),
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
            return GestureDetector(
              onTap: () => {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          InfoRecipeScreen(recipe: recipe),
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
                        child: Stack(children: [
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
                                        'https://static.thenounproject.com/png/380306-200.png')),
                            width: 150,
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: const [
                                      Icon(
                                        Icons.star_rounded,
                                        color: Colors.deepOrange,
                                      ),
                                      Icon(
                                        Icons.error_outline_rounded,
                                        color: Colors.redAccent,
                                      ),
                                      SizedBox(
                                        width: 5,
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                        ]),
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
          } else {
            return GestureDetector(
              onTap: () => {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          InfoRecipeScreen(recipe: recipe),
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
                        child: Stack(children: [
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
                                        'https://static.thenounproject.com/png/380306-200.png')),
                            width: 150,
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        color: Colors.deepOrange,
                                      ),
                                      Container(
                                        height: 12,
                                        width: 12,
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        child: const CircularProgressIndicator
                                            .adaptive(
                                          backgroundColor: Colors.deepOrange,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.black),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                        ]),
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
        });
  }
}

class _UserCard extends StatelessWidget {
  final User user;

  const _UserCard({
    Key? key,
    required this.user,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
        onTap: () => {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        ExternalProfile(userID: user.id!),
                  )),
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
                child: Row(children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: CircleAvatar(
                      maxRadius: 50,
                      backgroundImage: NetworkImage(user.urlImg!.isNotEmpty
                          ? user.urlImg!
                          : 'https://d500.epimg.net/cincodias/imagenes/2016/07/04/lifestyle/1467646262_522853_1467646344_noticia_normal.jpg'),
                    ),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          child: Text(user.username ?? 'username',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        )
                      ]),
                ]))));
  }
}

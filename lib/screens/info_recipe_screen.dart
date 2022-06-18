import 'package:be_chef_proyect/models/models.dart';
import 'package:be_chef_proyect/screens/external_profile.dart';
import 'package:be_chef_proyect/services/services.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../services/recipe_service.dart';
import '../services/services.dart';

class InfoRecipeScreen extends StatelessWidget {
  final Recipe recipe;

  const InfoRecipeScreen({Key? key, required this.recipe}) : super(key: key);

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
                  _ImageOfCard(urlImg: recipe.urlImg),
                ],
              ),
              _FormRecipe(recipe: recipe),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.close_rounded),
          backgroundColor: Colors.deepOrange,
          onPressed: () => {Navigator.of(context).pop()},
        ));
  }
}

class _ImageOfCard extends StatelessWidget {
  final String? urlImg;

  const _ImageOfCard({Key? key, required this.urlImg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
              color: Colors.deepOrange,
              height: 250,
              width: double.infinity,
              child: urlImg != null
                  ? FadeInImage(
                      placeholder: const AssetImage(
                        'assets/loading.gif',
                      ),
                      image: NetworkImage(urlImg!),
                      imageErrorBuilder: (context, error, stackTrace) =>
                          const Image(
                              image: NetworkImage(
                                  'https://static.thenounproject.com/png/380306-200.png')),
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : const Image(image: AssetImage('assets/bechef_logo.png'))),
        ),
      ),
    );
  }
}

class Auxdata {
  final String autor;
  final double rate;
  final double rateOfAutor;

  Auxdata(this.autor, this.rate, this.rateOfAutor);
}

class _FormRecipe extends StatelessWidget {
  final Recipe? recipe;

  const _FormRecipe({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipeService = Provider.of<RecipeService>(context, listen: false);
    final userService =
        Provider.of<DataUserLoggedService>(context, listen: false);

    Future<Auxdata> getData() async {
      String autorId = await recipeService.findUsernameById(
          context, recipe!.idAutor.toString());
      User u = await userService.getUserByToken(context);
      double rate = await recipeService.getRate(context, recipe!.id!);
      double rateOfAutor =
          await recipeService.getRateOfAutor(context, recipe!.id!, u.id!);
      return Auxdata(autorId, double.parse(rate.toStringAsPrecision(2)),
          double.parse(rateOfAutor.toStringAsPrecision(2)));
    }

    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Autor',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                ExternalProfile(userID: recipe!.idAutor!),
                          )),
                      child: Text((snapshot.data! as Auxdata).autor,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.deepOrange))),
                  const SizedBox(height: 10),
                  const Text('Nombre Receta',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(recipe!.name ?? 'Error'),
                  const SizedBox(height: 10),
                  const Text('Categoria',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(recipe!.category ?? 'Error'),
                  const SizedBox(height: 10),
                  const Text('Descripcion',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(recipe!.description ?? 'Error'),
                  const SizedBox(height: 10),
                  const Text('Pasos a seguir',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ExpandableText(
                    recipe!.steps ?? 'Error',
                    expandText: 'Ver mas',
                    collapseText: 'Ver menos',
                    maxLines: 5,
                    linkColor: Colors.deepOrange,
                  ),
                  const SizedBox(height: 10),
                  const Text('Valoracion',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.deepOrange,
                      ),
                      Text((snapshot.data! as Auxdata).rate.toString()),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Valorar',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  RatingBar(
                      initialRating: (snapshot.data! as Auxdata).rateOfAutor,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      ratingWidget: RatingWidget(
                          full: const Icon(
                            Icons.star_rounded,
                            color: Colors.deepOrange,
                          ),
                          half: const Icon(
                            Icons.star_half_rounded,
                            color: Colors.deepOrange,
                          ),
                          empty: const Icon(Icons.star_outline_rounded)),
                      onRatingUpdate: (rating) async {
                        await recipeService.saveRate(
                            context, recipe!.id!, recipe!.idAutor!, rating);
                      }),
                  const SizedBox(height: 10),
                ],
              )),
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Autor',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Rafael Carbon'),
                  SizedBox(height: 10),
                  Text('Nombre Receta',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Macarrones Carbonara'),
                  SizedBox(height: 10),
                  Text('Categoria',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Pasta'),
                  SizedBox(height: 10),
                  Text('Descripcion',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Macarrones Carbonara'),
                  SizedBox(height: 10),
                  Text('Pasos a seguir',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(
                      'Nombre Nostrud ut minim enim eu commodo consectetur reprehenderit aliqua mollit consectetur aute. Do esse enim nostrud deserunt dolor. Nulla reprehenderit pariatur adipisicing enim laborum. Amet sunt nostrud enim sit pariatur aliqua mollit esse ipsum proident eiusmod. Adipisicing tempor non occaecat nulla ullamco cillum cupidatat.Nisi excepteur mollit aute occaecat veniam veniam. Tempor ea nisi proident do sit consequat. Qui cillum tempor sit ex ea non fugiat minim eiusmod irure eiusmod aliqua incididunt consectetur. Est mollit minim ipsum consectetur duis mollit ullamco fugiat amet officia. Exercitation commodo sit occaecat elit commodo. Aute ipsum veniam dolore tempor elit laborum consequat non et sunt sit dolor. Deserunt sunt aute velit anim occaecat elit dolor aute.'),
                  SizedBox(height: 10),
                ],
              )),
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
                Text('Cargando información...',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
              ],
            );
          }
        });
  }
}

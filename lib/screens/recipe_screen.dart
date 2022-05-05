import 'dart:io';

import 'package:be_chef_proyect/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/providers.dart';
import '../services/services.dart';

class RecipeScreen extends StatelessWidget {

  final Recipe recipe;
  static Recipe? sRecipe;
  static File? newImg = null;
  static RecipeProvider? recipeProvider;
  
  const RecipeScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    recipeProvider = Provider.of<RecipeProvider>(context, listen: true);
    final recipeService = Provider.of<RecipeService>(context, listen: false);

    sRecipe = recipe;

    Future<void> modifyRecipe() async {
    if(recipeProvider!.nameChanged || recipeProvider!.descriptionChanged || recipeProvider!.stepsChanged || recipeProvider!.categoryChanged || recipeProvider!.urlImgChanged) {
      dynamic newRecipe = await recipeService.changeDataRecipe(context, recipe.id.toString(), sRecipe!.name, sRecipe!.description, sRecipe!.steps, sRecipe!.category, newImg);
      
      if(newRecipe.runtimeType == Recipe) {
        recipeProvider!.nameChanged = false;
        recipeProvider!.descriptionChanged = false;
        recipeProvider!.stepsChanged = false;
        recipeProvider!.categoryChanged = false;
        recipeProvider!.urlImgChanged = false;

        Navigator.of(context).pop();
      }else{
        NotificationsService.showSnackBar(newRecipe['error']);
      }
    }else 
      Navigator.of(context).pop();
    }

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
                const _ImageOfCard(imgUrl: ''),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.17,
                  left: MediaQuery.of(context).size.width * 0.41,
                  child: const Icon(Icons.camera_alt, color: Color.fromRGBO(255, 255, 255, 0.8), size: 80,),
                ),
              ],
            ),
            _FormRecipe(recipe: recipe),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save_rounded),
        backgroundColor: Colors.deepOrange,
        onPressed: () => {
          modifyRecipe()
        },
      )
    );
  }
}


class _ImageOfCard extends StatelessWidget {

  final String imgUrl;
  
  const _ImageOfCard({Key? key, required this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.deepOrange,
            height: 250,
            width: double.infinity,
            child: const FadeInImage(
              placeholder: AssetImage('/assets/bechef_logo.png'), 
              image: AssetImage('assets/bechef_logo.png'),
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            )
          ),
        ),
      ),
    );
  }
}

class _FormRecipe extends StatelessWidget {

  final Recipe recipe;
  
  const _FormRecipe({Key? key, required this.recipe}) : super(key: key);

  nameChanged(String value){
    RecipeScreen.sRecipe!.name = value;
    RecipeScreen.recipeProvider!.nameChanged = true;
  }

  dscChanged(String value){
    RecipeScreen.sRecipe!.description = value;
    RecipeScreen.recipeProvider!.descriptionChanged = true;
  }

  stepsChanged(String value){
    RecipeScreen.sRecipe!.steps = value;
    RecipeScreen.recipeProvider!.stepsChanged = true;
  }

  categoryChanged(String value){
    RecipeScreen.sRecipe!.category = value;
    RecipeScreen.recipeProvider!.categoryChanged = true;
  }

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        child: Column(
          children: [
            CustomInputField(color: Colors.deepOrange, labelText: 'Nombre', initialValue: recipe.name, hintText: 'Pizza Carbonara', validator: ( String value ) => value.length > 3 && value.length < 51 ? null : 'Debe tener entre 4 y 50 caracteres', onChange: (String value) => nameChanged(value)),
            CustomInputField(color: Colors.deepOrange, labelText: 'Descripción', initialValue: recipe.description , hintText: 'Es una receta proveniente de Italia...', validator: ( String value ) => value.length < 101 ? null : 'Debe tener menos de 100 caracteres', onChange: (String value) => dscChanged(value)),
            CustomInputField(color: Colors.deepOrange, labelText: 'Pasos a seguir', initialValue: recipe.steps,  hintText: '1.Primero deberemos...', validator: ( String value ) =>  value.length < 21 ? null : 'Debe tener menos de 20 caracteres', onChange: (String value) => stepsChanged(value)),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Categoría',
                labelStyle: TextStyle(color: Colors.black54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepOrange),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepOrange),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'Pasta', child: Text('Pastas')),
                DropdownMenuItem(value: 'Pizza', child: Text('Pizzas')),
                DropdownMenuItem(value: 'Ensalada', child: Text('Ensaladas')),
                DropdownMenuItem(value: 'Otros', child: Text('Otros')),
              ],
              value: recipe.category,
              onChanged: ( value ) => categoryChanged(value!),
            )
          ],
        )
      ),
    );
  }
}
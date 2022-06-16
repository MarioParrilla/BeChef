import 'dart:io';

import 'package:be_chef_proyect/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/providers.dart';
import '../services/services.dart';

class RecipeScreen extends StatelessWidget {
  final Recipe recipe;
  static Recipe? sRecipe;
  static File? newImg;
  static String newUrlImg = '';
  static RecipeProvider? recipeProvider;
  final bool type;

  const RecipeScreen({Key? key, required this.recipe, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    recipeProvider = Provider.of<RecipeProvider>(context, listen: true);
    final recipeService = Provider.of<RecipeService>(context, listen: false);
    final loggedUserRecipesProvider =
        Provider.of<LoggedUserRecipesProvider>(context, listen: true);

    sRecipe = recipe;
    newUrlImg = recipeProvider!.urlImg;

    final categoryService = Provider.of<CategoryService>(context);

    loadCategories(context) async {
      return (await categoryService.findCategories(context)).map((category) {
        return DropdownMenuItem<String>(
          value: category.name,
          child: Text(category.name),
        );
      }).toList();
    }

    Future<void> modifyRecipe() async {
      if (recipeProvider!.nameChanged ||
          recipeProvider!.descriptionChanged ||
          recipeProvider!.stepsChanged ||
          recipeProvider!.categoryChanged ||
          recipeProvider!.urlImgChanged) {
        dynamic newRecipe = await recipeService.changeDataRecipe(
            context,
            recipe.id.toString(),
            sRecipe!.name!,
            sRecipe!.description!,
            sRecipe!.steps!,
            sRecipe!.category!,
            newImg);

        if (newRecipe.runtimeType == Recipe) {
          recipeProvider!.nameChanged = false;
          recipeProvider!.descriptionChanged = false;
          recipeProvider!.stepsChanged = false;
          recipeProvider!.categoryChanged = false;
          recipeProvider!.urlImgChanged = false;
          recipeProvider!.urlImg = '';
          recipeProvider!.urlImgTemp = '';
          newImg = null;
          loggedUserRecipesProvider.replaceRecipe(newRecipe);

          Navigator.of(context).pop();
        } else {
          NotificationsService.showSnackBar(newRecipe['error']);
        }
      } else {
        Navigator.of(context).pop();
      }
    }

    Future<void> removeRecipe() async {
      await recipeService.removeRecipe(context, recipe.id!)
          ? Navigator.of(context).pop()
          : null;
      loggedUserRecipesProvider.removeRecipe(recipe.id!);
      recipeProvider!.nameChanged = false;
      recipeProvider!.descriptionChanged = false;
      recipeProvider!.stepsChanged = false;
      recipeProvider!.categoryChanged = false;
      recipeProvider!.urlImgChanged = false;
      recipeProvider!.urlImg = '';
      recipeProvider!.urlImgTemp = '';
      newImg = null;
    }

    Future<void> createRecipe() async {
      if (recipeProvider!.nameChanged ||
          recipeProvider!.descriptionChanged ||
          recipeProvider!.stepsChanged ||
          recipeProvider!.categoryChanged ||
          recipeProvider!.urlImgChanged) {
        dynamic newRecipe = await recipeService.changeDataRecipe(
            context,
            null,
            sRecipe!.name!,
            sRecipe!.description!,
            sRecipe!.steps!,
            sRecipe!.category!,
            newImg);

        if (newRecipe.runtimeType == Recipe) {
          recipeProvider!.nameChanged = false;
          recipeProvider!.descriptionChanged = false;
          recipeProvider!.stepsChanged = false;
          recipeProvider!.categoryChanged = false;
          recipeProvider!.urlImgChanged = false;
          recipeProvider!.urlImg = '';
          recipeProvider!.urlImgTemp = '';
          newImg = null;
          loggedUserRecipesProvider.addRecipe(newRecipe);

          Navigator.of(context).pop();
        } else {
          NotificationsService.showSnackBar(newRecipe['error']);
        }
      } else
        Navigator.of(context).pop();
    }

    AlertDialog alertDelete() {
      return AlertDialog(
        title: const Text("¿Desea eliminar la receta?"),
        content: Container(
          height: 130,
          child: Column(
            children: [
              TextButton(
                  onPressed: () async => {
                        Navigator.of(context).pop(),
                        await removeRecipe(),
                      },
                  child: const Text(
                    "Si",
                    style: TextStyle(color: Colors.deepOrange),
                  )),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.deepOrange),
                  )),
            ],
          ),
        ),
      );
    }

    return FutureBuilder(
        future: loadCategories(context),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
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
                      _ImageOfCard(urlImg: newUrlImg),
                      _FormRecipe(
                          recipe: recipe,
                          categories:
                              snapshot.data as List<DropdownMenuItem<String>>),
                    ],
                  ),
                ),
                floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    type
                        ? FloatingActionButton(
                            child: const Icon(Icons.delete),
                            backgroundColor: Colors.deepOrange,
                            onPressed: () async => showDialog(
                                context: context,
                                builder: (_) => alertDelete()),
                            heroTag: null,
                          )
                        : const SizedBox(),
                    const SizedBox(width: 10),
                    FloatingActionButton(
                      child: const Icon(Icons.save_rounded),
                      backgroundColor: Colors.deepOrange,
                      onPressed: () async =>
                          {type ? await modifyRecipe() : await createRecipe()},
                      heroTag: null,
                    )
                  ],
                ));
          } else if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white12,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              body: Center(
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
              )),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.close_rounded),
                backgroundColor: Colors.deepOrange,
                onPressed: () async => Navigator.of(context).pop(),
                heroTag: null,
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white12,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(height: 50),
                  CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.deepOrange,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text('Cargando información...',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                ],
              )),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.close_rounded),
                backgroundColor: Colors.deepOrange,
                onPressed: () async => Navigator.of(context).pop(),
                heroTag: null,
              ),
            );
          }
        });
  }
}

class _ImageOfCard extends StatelessWidget {
  String urlImg;

  _ImageOfCard({Key? key, required this.urlImg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile;

    takeGalleryImg() async {
      pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        RecipeScreen.newImg = File(pickedFile!.path);
        RecipeScreen.recipeProvider!.urlImg = pickedFile!.path;
        urlImg = pickedFile!.path;
        RecipeScreen.recipeProvider!.urlImgChanged = true;
        Navigator.of(context).pop();
      }
    }

    takeCameraImg() async {
      pickedFile = await imagePicker.getImage(source: ImageSource.camera);
      if (pickedFile != null) {
        RecipeScreen.newImg = File(pickedFile!.path);
        RecipeScreen.recipeProvider!.urlImg = pickedFile!.path;
        urlImg = pickedFile!.path;
        RecipeScreen.recipeProvider!.urlImgChanged = true;
        Navigator.of(context).pop();
      }
    }

    AlertDialog alert(BuildContext context) {
      return AlertDialog(
        title: Text("¿Como quieres elegir la imagen?"),
        content: Container(
          height: 140,
          child: Column(
            children: [
              const Text("Elige el metodo para escoger la imagen"),
              TextButton(
                  onPressed: () async => {takeCameraImg()},
                  child: const Text(
                    "Camara",
                    style: TextStyle(color: Colors.deepOrange),
                  )),
              TextButton(
                  onPressed: () async => {takeGalleryImg()},
                  child: const Text(
                    "Galeria",
                    style: TextStyle(color: Colors.deepOrange),
                  )),
            ],
          ),
        ),
      );
    }

    ImageProvider getImage(String? img) {
      if (img == null || img == '') {
        return const AssetImage('assets/bechef_logo.png');
      }

      if (img.startsWith('http')) {
        return NetworkImage(img);
      }

      return FileImage(File(img));
    }

    return GestureDetector(
      onTap: () async {
        showDialog(context: context, builder: (context) => alert(context));
      },
      child: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.deepOrange,
                  height: 250,
                  width: double.infinity,
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/bechef_logo.png'),
                    image: urlImg != null
                        ? getImage(urlImg)
                        : const NetworkImage(
                            'https://static.thenounproject.com/png/380306-200.png'),
                    imageErrorBuilder: (context, error, stackTrace) => const Image(
                        image: NetworkImage(
                            'https://static.thenounproject.com/png/380306-200.png')),
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.17,
            left: MediaQuery.of(context).size.width * 0.41,
            child: const Icon(
              Icons.camera_alt,
              color: Color.fromRGBO(255, 255, 255, 0.8),
              size: 80,
            ),
          ),
        ],
      ),
    );
  }
}

class _FormRecipe extends StatelessWidget {
  final Recipe? recipe;

  final List<DropdownMenuItem<String>> categories;

  const _FormRecipe({Key? key, required this.recipe, required this.categories})
      : super(key: key);

  nameChanged(String value) {
    RecipeScreen.sRecipe!.name = value;
    RecipeScreen.recipeProvider!.nameChanged = true;
  }

  dscChanged(String value) {
    RecipeScreen.sRecipe!.description = value;
    RecipeScreen.recipeProvider!.descriptionChanged = true;
  }

  stepsChanged(String value) {
    RecipeScreen.sRecipe!.steps = value;
    RecipeScreen.recipeProvider!.stepsChanged = true;
  }

  categoryChanged(String value) {
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
          CustomInputField(
              color: Colors.deepOrange,
              labelText: 'Nombre',
              initialValue: recipe != null ? recipe!.name : '',
              hintText: 'Pizza Carbonara',
              validator: (String value) => value.length > 3 && value.length < 51
                  ? null
                  : 'Debe tener entre 4 y 50 caracteres',
              onChange: (String value) => nameChanged(value)),
          CustomInputField(
              color: Colors.deepOrange,
              labelText: 'Descripción',
              initialValue: recipe != null ? recipe!.description : '',
              hintText: 'Es una receta proveniente de Italia...',
              validator: (String value) => value.length < 101
                  ? null
                  : 'Debe tener menos de 100 caracteres',
              onChange: (String value) => dscChanged(value)),
          CustomInputField(
              color: Colors.deepOrange,
              labelText: 'Pasos a seguir',
              initialValue: recipe != null ? recipe!.steps : '',
              hintText: '1.Primero deberemos...',
              keyboardType: TextInputType.multiline,
              maxLines: 70,
              validator: (String value) => value.length < 20001
                  ? null
                  : 'Debe tener menos de 1000 caracteres',
              onChange: (String value) => stepsChanged(value)),
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
            items: categories,
            value: recipe != null ? recipe!.category : null,
            onChanged: (value) => categoryChanged(value!),
          )
        ],
      )),
    );
  }
}

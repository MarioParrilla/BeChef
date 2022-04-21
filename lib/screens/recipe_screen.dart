import 'package:be_chef_proyect/widgets/widgets.dart';
import 'package:flutter/material.dart';

class RecipeScreen extends StatelessWidget {

  const RecipeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                const _ImageOfCard(),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.17,
                  left: MediaQuery.of(context).size.width * 0.41,
                  child: const Icon(Icons.camera_alt, color: Color.fromRGBO(255, 255, 255, 0.8), size: 80,),
                ),
              ],
            ),
            const _FormRecipe(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save_rounded),
        backgroundColor: Colors.deepOrange,
        onPressed: () => {},
      )
    );
  }
}


class _ImageOfCard extends StatelessWidget {

  const _ImageOfCard({Key? key}) : super(key: key);

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

  const _FormRecipe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        child: Column(
          children: [
            CustomInputField(color: Colors.deepOrange, labelText: 'Nombre', hintText: 'Pizza Carbonara', validator: (){}, onChange: (){},),
            CustomInputField(color: Colors.deepOrange, labelText: 'Descripción', hintText: 'Es una receta proveniente de Italia...', validator: (){}, onChange: (){}, ),
            CustomInputField(color: Colors.deepOrange, labelText: 'Pasos a seguir', hintText: '1.Primero deberemos...', validator: (){}, onChange: (){}, ),
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
                DropdownMenuItem(value: 'Pastas', child: Text('Pastas')),
                DropdownMenuItem(value: 'Pizzas', child: Text('Pizzas')),
                DropdownMenuItem(value: 'Ensaladas', child: Text('Ensaladas')),
                DropdownMenuItem(value: 'Otros', child: Text('Otros')),
              ], 
              onChanged: ( value ){}
            )
          ],
        )
      ),
    );
  }
}
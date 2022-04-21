import 'package:be_chef_proyect/widgets/widgets.dart';
import 'package:flutter/material.dart';

class InfoRecipeScreen extends StatelessWidget {

  const InfoRecipeScreen({Key? key}) : super(key: key);

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
              children: const [
                _ImageOfCard(),
              ],
            ),
            const _FormRecipe(),
          ],
        ),
      ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const  [
            Text('Autor', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Rafael Carbon'),
            SizedBox( height: 10),
            Text('Nombre Receta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Macarrones Carbonara'),
            SizedBox( height: 10),
            Text('Categoria', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Pasta'),
            SizedBox( height: 10),
            Text('Descripcion', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Macarrones Carbonara'),
            SizedBox( height: 10),
            Text('Pasos a seguir', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Nombre Nostrud ut minim enim eu commodo consectetur reprehenderit aliqua mollit consectetur aute. Do esse enim nostrud deserunt dolor. Nulla reprehenderit pariatur adipisicing enim laborum. Amet sunt nostrud enim sit pariatur aliqua mollit esse ipsum proident eiusmod. Adipisicing tempor non occaecat nulla ullamco cillum cupidatat.Nisi excepteur mollit aute occaecat veniam veniam. Tempor ea nisi proident do sit consequat. Qui cillum tempor sit ex ea non fugiat minim eiusmod irure eiusmod aliqua incididunt consectetur. Est mollit minim ipsum consectetur duis mollit ullamco fugiat amet officia. Exercitation commodo sit occaecat elit commodo. Aute ipsum veniam dolore tempor elit laborum consequat non et sunt sit dolor. Deserunt sunt aute velit anim occaecat elit dolor aute.'),
            SizedBox( height: 10),
          ],
        )
      ),
    );
  }
}
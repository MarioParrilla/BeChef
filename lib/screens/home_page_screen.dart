import 'package:be_chef_proyect/services/recipe_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final recipeService = Provider.of<RecipeService>(context);
;

    return Container(
      child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: const [
                _HorizontalRecipes(title: 'Populares', images: [NetworkImage('https://cdn.colombia.com/gastronomia/2011/08/25/macarrones-a-la-mediterranea-3327.jpg'),NetworkImage('https://www.hola.com/imagenes/cocina/recetas/20220208204252/pizza-pepperoni-mozzarella/1-48-890/pepperoni-pizza-abob-t.jpg'), NetworkImage('https://eldiariony.com/wp-content/uploads/sites/2/2020/04/shutterstock_1564648540.jpg?quality=60&strip=all&w=1200')]),
                _HorizontalRecipes(title: 'Pastas', images: [NetworkImage('https://cdn.colombia.com/gastronomia/2011/08/25/macarrones-a-la-mediterranea-3327.jpg'), NetworkImage('https://ep01.epimg.net/elcomidista/imagenes/2021/07/19/receta/1626705057_440757_1630339369_media_normal.jpg'), NetworkImage('https://images.aws.nestle.recipes/resized/1828b2ea10adc8c9f710fcf959a55a51_PASTA-AL-ROMERO-Lunch_1200_600.png'), NetworkImage('https://imag.bonviveur.com/ensalada-de-pasta-con-atun.jpg')]),
                _HorizontalRecipes(title: 'Pizzas', images: [NetworkImage('https://www.hola.com/imagenes/cocina/recetas/20220208204252/pizza-pepperoni-mozzarella/1-48-890/pepperoni-pizza-abob-t.jpg'), NetworkImage('https://estaticos-cdn.epe.es/clip/afd47ec1-5c88-40aa-a91c-a873f9b5537a_alta-libre-aspect-ratio_default_0.png'), NetworkImage('https://static2.diariosur.es/www/multimedia/202204/01/media/cortadas/pizza-kI0F-U16015210189230G-1248x770@RC.jpg'), NetworkImage('https://dcom-prod.imgix.net/files/wp-content/uploads/2016/06/1465586619-Pizzas-exoticas.jpg?w=1280&h=720&crop=focalpoint&fp-x=0.5&fp-y=0.1&fit=crop&auto=compress&q=75')]),
                _HorizontalRecipes(title: 'Ensaladas', images: [NetworkImage('https://cdn2.cocinadelirante.com/sites/default/files/styles/gallerie/public/images/2021/06/recetas-de-ensaladas-con-lechuga-y-frutas.jpg'), NetworkImage('https://www.laylita.com/recetas/wp-content/uploads/Ensalada-de-lechuga-con-limon-y-cilantro.jpg'), NetworkImage('https://eldiariony.com/wp-content/uploads/sites/2/2020/04/shutterstock_1564648540.jpg?quality=60&strip=all&w=1200'), NetworkImage('https://elgourmet.s3.amazonaws.com/recetas/cover/1541ed32f2096258878b133fb9b170dd_3_3_photo.png')]),
              ],
          ),
      )
    );
  }
}

class _HorizontalRecipes extends StatelessWidget {

  final String title;
  final List<NetworkImage> images;

  const _HorizontalRecipes({ Key? key, required this.title, required this.images }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ScrollController scrollController = ScrollController();

    return Container(
      width: double.infinity,
      height: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox( height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  title, 
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 3, top: 3),
                  child: const Icon(Icons.arrow_forward_ios_outlined, size: 15, color: Colors.black)
                ),
              ],
            )
          ),

              const SizedBox(height: 5),

              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: images.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => _RecipeCard(img: images[index],)
                ),
              ),
        ]
      )
    );
  }
}

class _RecipeCard extends StatelessWidget {

  final NetworkImage img;

  const _RecipeCard({Key? key, required this.img}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {/*Navigator.of(context).pushNamed('recipe')*/},
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: 
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              child: FadeInImage(
            placeholder: const AssetImage('assets/bechef_logo.png'), 
            image: img,
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
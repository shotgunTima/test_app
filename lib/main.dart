import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(TestApp());
}

class TestApp extends StatelessWidget{
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: const searchPage(),
    );
  }


}

class searchPage extends StatefulWidget {
  const searchPage({super.key});

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {

  List<dynamic> drinks = [];
  String query = '';
  bool isLoad = false;
  final Dio _dio = Dio();

  Future<void> searchPage(String searchQue) async{

    if (searchQue.isEmpty) return;
    setState(() {
      isLoad = true;
    });

    try{
      final response = await _dio.get(
        'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$searchQue'
      );

      final data = response.data;
      setState(() {
        drinks = data['drinks'] ?? [];
        isLoad = false;
      });


    } catch (i){
      setState(() {
        drinks = [];
        isLoad = false;
      });
    }

  }



  Widget drinkCard(dynamic drink){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.all(5),

      child: 
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    drink['strDrinkThumb'],
                    height: 150,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                        drink['strDrink'] ?? 'No Name',
                        style: TextStyle(
                          fontSize:20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                      Text('Тип: ${drink['strAlcoholic'] ?? 'No Name'}'),
                      Text('Категория: ${drink['strCategory'] ?? 'No Name'}'),
                      Text(
                        drink['strPrice'] ?? '0c',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10,),
                      // child: Icon(Icons.arrow_outward_outlined)


                      OutlinedButton (onPressed: (){},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('В корзину', style: TextStyle(color: Colors.black87 ),),

                          Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color.fromRGBO(98, 130, 50, 1),
                            ),
                            child: Icon(
                              Icons.arrow_outward_rounded,
                              color: Colors.white,

                              ),
                          ),
                        ],
                      )
                    ),        
                  ]
                )
              ],
            ),
          ),
      );
  }

  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsets.fromLTRB(10, 100, 10, 0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Найти..',
              prefixIcon: Icon(Icons.search_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onSubmitted: (text){
              query = text;
              searchPage(text);
            },
          ),
          ),

          if(isLoad)
            Center(
              child: CircularProgressIndicator(),
              ),

          if(!isLoad && drinks.isEmpty && query.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(16),
              child: Text('Прости, мы не нашли $query :('),
            ), 

          if (!isLoad && drinks.isNotEmpty) 
              Expanded(
                child: GridView.builder(
                itemCount: drinks.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,         
                  crossAxisSpacing: 0, 
                  mainAxisSpacing: 0,     
                  childAspectRatio: 0.58,  
                ),

            itemBuilder: (context, index) {
              return drinkCard(drinks[index]);
            },
          ),
        )
        ],
      )
    );
  }
}
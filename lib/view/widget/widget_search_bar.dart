import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:franko_mobile_app/view/pages/product/product_details.dart';


class ProductSearch extends SearchDelegate<String> {


  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {
      query = " ";
      if(query == " ") return buildNoSuggestions("Search for a product");
     
    })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder <List<Products>>(
     future: APIService().searchproduct(query),
     //Provider.of<SearchProvider>(context, listen: false).fetchquery(query: query ),
     builder: (context, data) {
       if(query.isEmpty) return buildNoSuggestions("Search for a product");
       switch (data.connectionState) {
         case ConnectionState.waiting : 
         return Center(child: CircularProgressIndicator());
         default: if(data.data.isEmpty) {
           print(data.error);
           return buildNoSuggestions("Search cannot find $query, please search again");
           //Text('Error ${data.error}');
         } else {
           //print(data.data);
          return buildSuggestionsWidget(data.data);
         }
         //buildSuggestionsWidget(data.data);
       }
     },
   );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder <List<Products>>(
     future: APIService().searchproduct(query),
     //Provider.of<SearchProvider>(context, listen: false).fetchquery(query: query ),
     builder: (context, data) {
       if(query.isEmpty) return buildNoSuggestions("Search for a product");
       switch (data.connectionState) {
         case ConnectionState.waiting : 
         return Center(child: CircularProgressIndicator());
         default: if(data.data.isEmpty) {
           print(data.error);
           return buildNoSuggestions("Search cannot find $query, please search again");
           //Text('Error ${data.error}');
         } else {
           //print(data.data);
          return buildSuggestionsWidget(data.data);
         }
         //buildSuggestionsWidget(data.data);
       }
     },
   );
  }

  Widget buildNoSuggestions(String text) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(fontSize: 15),
      )
    );
  }

  Widget buildSuggestionsWidget(List<Products> suggestions) => ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => GestureDetector(
              child: ListTile(
            title:Text(suggestions[index].name.toLowerCase()),
            subtitle: Text("GHS ${suggestions[index].price}", style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProductDetails(product: suggestions[index]),
                  ),
                );
            },
          ),
      ),
  );
}


  

  
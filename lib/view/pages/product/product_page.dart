import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/provider/products_provider.dart';
import 'package:franko_mobile_app/view/widget/base_page.dart';
import 'package:franko_mobile_app/view/widget/widget_products_card.dart';
import 'package:provider/provider.dart';

class SortBy {
  String value;
  String text;
  String sortOrder;

  SortBy(this.value, this.text, this.sortOrder);
}

// ignore: must_be_immutable
class ProductPage extends BasePage {
  ProductPage(
      {Key key, this.categoryId, this.order, this.categoryName, this.status})
      : super(key: key);

  String categoryId;
  String order = "desc";
  String categoryName;
  String status = "publish";

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends BasePageState<ProductPage> {
  

  int pageNumber = 1;
  ScrollController _scrollController = ScrollController();

  // ignore: unused_field
  final _filterOptions = [
    SortBy("popularity", "Popularity", "desc"),
    SortBy("modified", "Latest", "desc"),
    SortBy("price", "Price: High to Low", "desc"),
    SortBy("price", "Price: High to Low", "desc"),
  ];
  @override
  void initState() {
    var _productList = Provider.of<ProductProvider>(context, listen: false);
    _productList.resetStreams();
    _productList.setLoadingState(LoadMoreStatus.INITIAL);
    _productList.fetchProducts(pageNumber,
        categoryId: widget.categoryId, status: "publish");

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _productList.setLoadingState(LoadMoreStatus.LOADING);
        _productList.fetchProducts(
          ++pageNumber,
          categoryId: widget.categoryId,
        );
      }
    });

    super.initState();
  }

  @override
  Widget pageUI() {
    return _productsList();
  }

  Widget _productsList() {
    return new Consumer<ProductProvider>(
      builder: (context, model, child) {
        if (model.allProducts != null &&
            model.allProducts.length > 0 &&
            model.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
          return _buildList(model.allProducts,
              model.getLoadMoreStatus() == LoadMoreStatus.LOADING);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildList(List<Products> items, bool isLoadMore) {
    return Column(
      children: [
        Flexible(
            child: GridView.count(
          shrinkWrap: true,
          controller: _scrollController,
          crossAxisCount: 2,
          physics: ClampingScrollPhysics(),
          children: items.map((Products item) {
            return ProductCard(data: item);
          }).toList(),
        )),
        Visibility(
          child: Container(
            padding: EdgeInsets.all(5),
            height: 35.0,
            width: 35.0,
            child: CircularProgressIndicator(),
          ),
          visible: isLoadMore,
        )
      ],
    );
  }

  // ignore: unused_element
  Widget _productFilter() {
    return Container(
      height: 51,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
                decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Search",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide.none,
              ),
              fillColor: Color(0xffe6e6ec),
              filled: true,
            )),
          ),
          SizedBox(width: 15),
          Container(
            decoration: BoxDecoration(
              color: Color(0xffe6e6ec),
              borderRadius: BorderRadius.circular(9.0),
            ),
            // ignore: missing_required_param
            child: PopupMenuButton(
              onSelected: (sortBy) {},
            ),
          )
        ],
      ),
    );
  }
}

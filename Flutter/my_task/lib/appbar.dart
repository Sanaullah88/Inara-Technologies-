import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function()? onClosePressed;
  final List<String> products;
  final Function(String)? onProductSelected;

  MyAppBar({
    required this.title,
    this.onClosePressed,
    required this.products,
    this.onProductSelected,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: onClosePressed,
      ),
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: onProductSelected,
          itemBuilder: (BuildContext context) {
            return products.map((String product) {
              return PopupMenuItem<String>(
                value: product,
                child: Text(product),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}

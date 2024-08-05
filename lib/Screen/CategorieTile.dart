import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String typetab;
  final String NameItem;
  final String imageUrl;
  final Alignment imageAlignment;
  final VoidCallback onTap ;

  const CategoryTile({
    required this.imageUrl,
    required this.NameItem,
    required this.typetab,
    this.imageAlignment = Alignment.center,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              colorBlendMode: BlendMode.darken,
              alignment: imageAlignment,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withOpacity(0.3),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                NameItem,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

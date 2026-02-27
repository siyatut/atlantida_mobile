import 'package:flutter/material.dart';

import '../../domain/product.dart';
import '../../utils/text_utils.dart';

import 'utils/product_description_parser.dart';
import 'widgets/product_details_contact_card.dart';
import 'widgets/product_details_description_card.dart';
import 'widgets/product_details_image_card.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final description = fixPrepositions(
      cleanProductDescription(product.description),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 72,
        title: Text(
          splitTitleInTwo(product.title),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProductDetailsImageCard(imageUrl: product.image),
              const SizedBox(height: 24),
              ProductDetailsDescriptionCard(text: description),
              const SizedBox(height: 20),
              ProductDetailsContactCard(productTitle: product.title),
            ],
          ),
        ),
      ),
    );
  }
}

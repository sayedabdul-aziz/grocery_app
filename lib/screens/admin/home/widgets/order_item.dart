import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grocery_app/core/utils/app_text_styles.dart';
import 'package:grocery_app/core/utils/colors.dart';

class OrderItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String location;
  final String rating;

  const OrderItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.shadeColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          )),
      child: Row(
        children: [
          SizedBox(
            height: 90,
            width: 150,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Image.asset('assets/logo.png');
                },
              ),
            ),
          ),
          const Gap(15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(name, style: getbodyStyle()),
                const Gap(5),
                Row(
                  children: [
                    const Icon(Icons.star),
                    const SizedBox(width: 5),
                    Text(rating, style: getbodyStyle()),
                  ],
                ),
                const Gap(10),
                Row(
                  children: [
                    const Icon(Icons.location_city_rounded),
                    const SizedBox(width: 5),
                    Text(
                      'Nasr City, Cairo',
                      style: getbodyStyle(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(10),
        ],
      ),
    );
  }
}

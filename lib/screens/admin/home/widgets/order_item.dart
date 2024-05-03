import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grocery_app/core/utils/app_text_styles.dart';
import 'package:grocery_app/core/utils/colors.dart';

class OrderItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String? quntity;
  final String date;
  final String price;
  final String productName;

  const OrderItem(
      {super.key,
      required this.imageUrl,
      required this.productName,
      required this.name,
      this.quntity,
      required this.date,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.shadeColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          )),
      child: Column(
        children: [
          Row(
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: getTitleStyle(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    if (quntity != null) ...{
                      Row(
                        children: [
                          const Icon(
                            Icons.production_quantity_limits_rounded,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            quntity ?? '',
                            style: getbodyStyle(),
                          ),
                        ],
                      ),
                      const Gap(10),
                    },
                    Row(
                      children: [
                        const Icon(
                          Icons.attach_money_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          price,
                          style: getbodyStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(5),
            ],
          ),
          const Gap(5),
          const Divider(),
          const Gap(5),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(name, style: getbodyStyle()),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.date_range_rounded,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(date, style: getbodyStyle()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

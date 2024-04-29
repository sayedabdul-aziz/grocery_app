import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/core/utils/app_text_styles.dart';

class HotelsList extends StatelessWidget {
  const HotelsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('All Hotels', style: getTitleStyle()),
              InkWell(
                onTap: () {
                  // navigateTo(context, const AllHotelsList());
                },
                child: Row(
                  children: [
                    Text('See all', style: getbodyStyle()),
                    const SizedBox(width: 6.5),
                    const Icon(Icons.arrow_forward_ios_sharp),
                  ],
                ),
              ),
            ],
          ),
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance.collection('hotels').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              var hotels = snapshot.data!.docs;
              return Container(
                height: 239,
                margin: const EdgeInsets.only(bottom: 25),
                child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: hotels.length,
                    itemBuilder: (context, index) {
                      return null;

                      // HotelModel hotel =
                      //     HotelModel.fromJson(hotels[index].data());

                      // return HotelItem(model: hotel);
                    },
                  ),
                ),
              );
            }),
      ],
    );
  }
}

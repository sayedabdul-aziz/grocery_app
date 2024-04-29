import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/utils/app_text_styles.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/core/widgets/custom_button.dart';

class EditFoodDetailsView extends StatefulWidget {
  const EditFoodDetailsView({
    super.key,
    required this.id,
  });
  final String id;

  @override
  State<EditFoodDetailsView> createState() => _EditFoodDetailsViewState();
}

class _EditFoodDetailsViewState extends State<EditFoodDetailsView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _message = TextEditingController();
  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  int quantity = 1;
  int rate = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('menu-list')
              .doc(widget.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var itemData = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: AppColors.white),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                              itemData!['image'],
                              height: 250,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.white,
                                child: Icon(
                                  Icons.edit,
                                  color: AppColors.white,
                                )),
                          )
                        ],
                      ),
                    ),
                    const Gap(20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(itemData['name'],
                              style: getTitleStyle().copyWith(
                                fontSize: 27,
                                letterSpacing: 1.5,
                                fontFamily: GoogleFonts.lato().fontFamily,
                              )),
                        ),
                        const Gap(20),
                        IconButton(
                          onPressed: () {
                            showEditDialog('name', itemData['name']);
                          },
                          icon: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.white,
                              child: Icon(
                                Icons.edit,
                                color: AppColors.white,
                              )),
                        )
                      ],
                    ),
                    const Gap(10),
                    if (itemData['description'] != '')
                      Row(
                        children: [
                          Text('Description',
                              style: getTitleStyle().copyWith(
                                fontFamily: GoogleFonts.lato().fontFamily,
                              )),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              showEditDialog(
                                  'description', itemData['description']);
                            },
                            icon: CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.white,
                                child: Icon(
                                  Icons.edit,
                                  color: AppColors.white,
                                )),
                          )
                        ],
                      ),
                    const Gap(5),
                    if (itemData['description'] != '')
                      Text(
                        itemData['description'],
                        style:
                            getTitleStyle(color: AppColors.white, fontSize: 12),
                      ),
                    const Gap(15),
                    Row(
                      children: [
                        Text(
                          'EGP ${((itemData['offer_persent'] != 0) ? (itemData['price'] * (100 - itemData['offer_persent']) * .01).toString() : itemData['price']).toString()}',
                          style: getTitleStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if ((itemData['offer_persent']) != 0)
                          Text(
                            'EGP ${itemData['price']}',
                            style: getTitleStyle(
                                    color: AppColors.white.withOpacity(.5),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12)
                                .copyWith(
                                    decorationColor:
                                        AppColors.white.withOpacity(.5),
                                    decoration: TextDecoration.lineThrough),
                          ),
                        const Spacer(),
                        if ((itemData['offer_persent']) != 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              '${(itemData['offer_persent'])}% OFF',
                              style: getsmallStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        IconButton(
                          onPressed: () {
                            showEditDialog('price', itemData['price']);
                          },
                          icon: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.white,
                              child: Icon(
                                Icons.edit,
                                color: AppColors.white,
                              )),
                        )
                      ],
                    ),
                    const Gap(10),
                    Divider(
                      color: AppColors.white,
                    ),
                    const Gap(15),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showSaleDialog(
                                  'offer_persent', itemData['offer_persent']);
                            },
                            child: Ink(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 17),
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'SALE',
                                  style: getbodyStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Ink(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.redColor),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'DELETE',
                                  style: getbodyStyle(
                                      color: AppColors.redColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<void> updateData(String key, value) async {
    if (key != 'offer_persent') {
      FirebaseFirestore.instance.collection('menu-list').doc(widget.id).set({
        key: value,
      }, SetOptions(merge: true));
    } else {
      FirebaseFirestore.instance.collection('menu-list').doc(widget.id).set({
        'is_offer': value == 0 ? false : true,
        'offer_persent': value,
      }, SetOptions(merge: true));
    }
  }

  showEditDialog(key, value) {
    showDialog(
        context: context,
        builder: (context) {
          var con = TextEditingController(text: value.toString());
          var form = GlobalKey<FormState>();
          return SimpleDialog(
            backgroundColor: AppColors.accentColor,
            alignment: Alignment.center,
            contentPadding: const EdgeInsets.all(10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            children: [
              Form(
                key: form,
                child: Column(
                  children: [
                    Text(
                      'Edit the $key',
                      style: getTitleStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: con,
                      // decoration: InputDecoration(
                      //     hintText: value[index]),
                      maxLines: 3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required*';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      text: 'EDIT',
                      onTap: () {
                        if (form.currentState!.validate()) {
                          updateData(
                            key,
                            (key == 'price')
                                ? double.parse(con.text)
                                : con.text,
                          );
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  showSaleDialog(key, value) {
    int index = value;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              backgroundColor: AppColors.accentColor,
              alignment: Alignment.center,
              contentPadding: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    for (int i = 0; i <= 70; i += 5) ...{
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = i;
                          });
                        },
                        child: ChoiceChip(
                            onSelected: (value) {
                              setState(() {
                                index = i;
                              });
                            },
                            backgroundColor: AppColors.darkScaffoldbg,
                            selectedColor: AppColors.primary,
                            checkmarkColor: AppColors.white,
                            selected: (i == index) ? true : false,
                            label: Text(
                              '$i%',
                              style: getbodyStyle(
                                  color: (i == index)
                                      ? AppColors.white
                                      : AppColors.primary),
                            )),
                      ),
                    },
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      text: 'SALE',
                      onTap: () {
                        updateData(
                          key,
                          index,
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            );
          });
        });
  }
}

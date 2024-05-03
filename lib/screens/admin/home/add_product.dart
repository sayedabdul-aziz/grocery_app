import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grocery_app/core/utils/app_text_styles.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/core/widgets/custom_button.dart';
import 'package:grocery_app/models/products_model.dart';
import 'package:image_picker/image_picker.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key, this.model});

  final ProductsModel? model;

  @override
  _AddProductViewScreenState createState() => _AddProductViewScreenState();
}

class _AddProductViewScreenState extends State<AddProductView> {
  late TextEditingController _nameController;
  late TextEditingController _price;
  late TextEditingController salePrice;
  final formKey = GlobalKey<FormState>();

  String? _imagePath;
  File? file;
  String? coverUrl;

  late String category;
  late bool isSale;
  late bool isPiece;

  @override
  void initState() {
    coverUrl = widget.model?.imageUrl;
    _nameController = TextEditingController(text: widget.model?.title);
    _price = TextEditingController(text: widget.model?.price.toString());
    salePrice = TextEditingController(text: widget.model?.salePrice.toString());
    category = widget.model?.productCategoryName ?? 'Vegetables';
    isSale = widget.model?.isOnSale ?? false;
    isPiece = widget.model?.isPiece ?? false;
    super.initState();
  }

  uploadImageToFireStore(File image, String imageName) async {
    Reference ref = FirebaseStorage.instanceFor(
            bucket: 'gs://grocery-app-771e8.appspot.com')
        .ref()
        .child('products/${DateTime.now().toIso8601String()}$imageName');
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putFile(image, metadata);
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        file = File(pickedFile.path);
      });
    }
    coverUrl = await uploadImageToFireStore(file!, 'cover');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model == null ? 'Add Product' : 'Edit Product'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('products')
                    .doc(widget.model?.title)
                    .delete();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomButton(
          text: widget.model == null ? 'Add Product' : 'Save Changes',
          onTap: () {
            if (formKey.currentState!.validate() && coverUrl != null) {
              formKey.currentState!.save();
              FirebaseFirestore.instance
                  .collection("products")
                  .doc(_nameController.text)
                  .set(
                      ProductsModel(
                              id: _nameController.text,
                              title: _nameController.text,
                              orderCount: widget.model == null
                                  ? 0
                                  : widget.model!.orderCount,
                              imageUrl: coverUrl.toString(),
                              productCategoryName: category,
                              price: double.parse(_price.text),
                              salePrice: double.parse(salePrice.text),
                              isOnSale: isSale,
                              isPiece: isPiece)
                          .toJson(),
                      SetOptions(merge: true));
              if (widget.model != null && isSale) {
                FirebaseFirestore.instance
                    .collection("offers")
                    .where('productName', isEqualTo: widget.model?.title)
                    .get()
                    .then((value) {
                  if (value.docs.isNotEmpty) {
                    // update status to 1
                    FirebaseFirestore.instance
                        .collection("offers")
                        .doc(value.docs.first.id)
                        .update({'status': '1'});
                  }
                });
              }
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const Text('Cover'),
              const Gap(5),
              InkWell(
                onTap: () {
                  _pickImage();
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: coverUrl == null
                      ? BoxDecoration(
                          border: Border.all(color: AppColors.shadeColor),
                          borderRadius: BorderRadius.circular(10),
                        )
                      : BoxDecoration(
                          border: Border.all(color: AppColors.shadeColor),
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(coverUrl!))),
                  child: Icon(
                    Icons.add,
                    color: AppColors.white,
                  ),
                ),
              ),
              const Gap(16),
              const Text('Product Name'),
              const Gap(5),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '* Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              const Text('Category'),
              const Gap(5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.shadeColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    elevation: 16,
                    underline: const SizedBox(),
                    isExpanded: true,
                    items: catInfo
                        .map((e) => DropdownMenuItem(
                            value: e['catText'].toString(),
                            child: Text('${e['catText']}')))
                        .toList(),
                    style: getbodyStyle(),
                    onChanged: (String? newValue) {
                      setState(() {
                        category = newValue!;
                      });
                    }),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text('is Piece'),
                  Checkbox(
                    value: isPiece,
                    onChanged: (value) {
                      setState(() {
                        isPiece = value!;
                      });
                    },
                  ),
                ],
              ),
              const Gap(15),
              const Text('Price'),
              const Gap(5),
              TextFormField(
                controller: _price,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '* Required';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: 'Ex: 20'),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text('On Sale'),
                  Checkbox(
                    value: isSale,
                    onChanged: (value) {
                      setState(() {
                        isSale = value!;
                      });
                    },
                  ),
                ],
              ),
              const Gap(15),
              const Text('Sale Price'),
              const Gap(5),
              TextFormField(
                controller: salePrice,
                readOnly: !isSale,
                decoration: InputDecoration(
                    hintText: !isSale ? 'Check On Sale Price first' : 'ex: 15'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> catInfo = [
  {
    'imgPath': 'assets/images/cat/fruits.png',
    'catText': 'Fruits',
  },
  {
    'imgPath': 'assets/images/cat/veg.png',
    'catText': 'Vegetables',
  },
  {
    'imgPath': 'assets/images/cat/Spinach.png',
    'catText': 'Herbs',
  },
  {
    'imgPath': 'assets/images/cat/nuts.png',
    'catText': 'Nuts',
  },
  {
    'imgPath': 'assets/images/cat/spices.png',
    'catText': 'Spices',
  },
  {
    'imgPath': 'assets/images/cat/grains.png',
    'catText': 'Grains',
  },
];

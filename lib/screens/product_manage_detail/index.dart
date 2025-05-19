import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/common/constants.dart';
import 'package:flutter_app/controllers/product_manager_controller.dart';
import 'package:flutter_app/screens/product_manage_detail/widgets/image_picker.dart';
import 'package:flutter_app/screens/product_manage_detail/widgets/switch_active.dart';
import 'package:flutter_app/services/product_service.dart';
import 'package:flutter_app/utils/showSnackBar.dart';
import 'package:flutter_app/widgets/text_form_field_custome.dart';
import 'package:get/get.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/header.dart';

class ProductManageDetail extends StatefulWidget {
  const ProductManageDetail({super.key});

  @override
  State<ProductManageDetail> createState() => _ProductManageDetailState();
}

class _ProductManageDetailState extends State<ProductManageDetail> {
  late DetailType type;
  Products? product;
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerSku = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerQuantity = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  File? image;
  bool isActive = true;
  ProductManagerController productManagerController = Get.find();
  bool _isLoading = false;
  String initImage = '';

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    type = args['type'] as DetailType;
    product = args['product'] as Products?;

    if (product != null) {
      controllerSku.text = product!.sku;
      controllerName.text = product!.name;
      controllerDescription.text = product!.description;
      controllerQuantity.text = product!.quantity.toString();
      controllerPrice.text = product!.price.toString();

      isActive = product!.isActive;
      initImage = product!.imageUrl;
    }
  }

  void handleSetImage(File? file) {
    setState(() {
      image = file;
    });
    if (file == null) {
      setState(() {
        initImage = '';
      });
    }
  }

  void handleChangeActive(bool value) {
    setState(() {
      isActive = value;
    });
  }

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        if (type == DetailType.add) {
          final response = await ProductService().addProduct(
            sku: controllerSku.text,
            name: controllerName.text,
            description: controllerDescription.text,
            price: controllerPrice.text,
            quantity: controllerQuantity.text,
            isActive: isActive,
            file: image,
          );

          productManagerController.addProduct(response);
          Get.back();
          showSnackBar(message: "Added product success");
        } else if (type == DetailType.update) {
          final response = await ProductService().updateProduct(
            id: product!.id,
            sku: controllerSku.text,
            name: controllerName.text,
            description: controllerDescription.text,
            price: controllerPrice.text,
            quantity: controllerQuantity.text,
            isActive: isActive,
            file: image,
            removeImage: initImage == '',
          );

          productManagerController.updateProduct(response);
          Get.back();
          showSnackBar(message: "Updated product success");
        }
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = type == DetailType.add ? "Add Product" : "Edit Product";

    return AppScaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          Header(icon: Icons.post_add_rounded, title: title, iconColor: Colors.blue),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ImagePickerWidget(
                    image: image,
                    handleSetImage: handleSetImage,
                    initImage: initImage == '' ? null : initImage,
                  ),
                  SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormFieldCustom(
                          controllerInput: controllerSku,
                          label: "Sku ",
                          type: FieldType.text,
                          prefixIcon: Icon(Icons.tag, color: Colors.blue),
                          onFieldSubmitted: (_) {},
                        ),
                        TextFormFieldCustom(
                          controllerInput: controllerName,
                          label: "Name ",
                          type: FieldType.text,
                          prefixIcon: Icon(Icons.label, color: Colors.blue),
                          onFieldSubmitted: (_) {},
                        ),
                        TextFormFieldCustom(
                          controllerInput: controllerDescription,
                          label: "Description ",
                          type: FieldType.text,
                          prefixIcon: Icon(Icons.notes, color: Colors.blue),
                          onFieldSubmitted: (_) {},
                        ),
                        TextFormFieldCustom(
                          controllerInput: controllerQuantity,
                          label: "Quantity ",
                          type: FieldType.text,
                          prefixIcon: Icon(Icons.inventory, color: Colors.blue),
                          onFieldSubmitted: (_) {},
                          isNumber: true,
                          isBlockFirstZero: true,
                        ),
                        TextFormFieldCustom(
                          controllerInput: controllerPrice,
                          label: "Price ",
                          type: FieldType.text,
                          prefixIcon: Icon(Icons.attach_money, color: Colors.blue),
                          onFieldSubmitted: (_) {},
                          isNumber: true,
                          isBlockFirstZero: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the price';
                            }

                            final numValue = num.tryParse(value);
                            if (numValue == null) {
                              return 'Price must be a valid number';
                            }

                            if (numValue < 1 || numValue > 5000) {
                              return 'Price must be greater than 1 and less than 5000';
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SwitchActive(active: isActive, handleChange: handleChangeActive),

                  Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : handleSubmit,
                      label:
                          _isLoading
                              ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                              : const Text("Submit", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLoading ? Colors.grey : Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

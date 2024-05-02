import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/core/utils/app_text_styles.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/screens/auth/login.dart';
import 'package:grocery_app/screens/loading_manager.dart';

import '../../core/consts/firebase_consts.dart';
import '../../core/services/global_methods.dart';
import '../../core/widgets/auth_button.dart';
import '../../core/widgets/text_widget.dart';
import '../../fetch_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/RegisterScreen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  bool _obscureText = true;
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _addressTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitFormOnRegister() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        final User? user = authInstance.currentUser;
        final uid = user!.uid;
        user.updateDisplayName(_fullNameController.text);
        user.updatePhotoURL('0');
        user.reload();
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'id': uid,
          'name': _fullNameController.text,
          'email': _emailTextController.text.toLowerCase(),
          'shipping-address': _addressTextController.text,
          'userWish': [],
          'userCart': [],
          'createdAt': Timestamp.now(),
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const FetchScreen(),
        ));
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: <Widget>[
            Image.asset(
              'assets/images/landing/vergtablebg.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(
                    height: 60.0,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.canPop(context)
                        ? Navigator.pop(context)
                        : null,
                    child: const Icon(
                      IconlyLight.arrowLeft2,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  TextWidget(
                    text: 'Welcome',
                    color: Colors.white,
                    textSize: 30,
                    isTitle: true,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextWidget(
                    text: "Sign up to continue",
                    color: Colors.white,
                    textSize: 18,
                    isTitle: false,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_emailFocusNode),
                          keyboardType: TextInputType.name,
                          controller: _fullNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This Field is missing";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Full name',
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passFocusNode),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextController,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains("@")) {
                              return "Please enter a valid Email adress";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //Password
                        TextFormField(
                          focusNode: _passFocusNode,
                          obscureText: _obscureText,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passTextController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return "Please enter a valid password";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_addressFocusNode),
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                            ),
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        TextFormField(
                          focusNode: _addressFocusNode,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: _submitFormOnRegister,
                          controller: _addressTextController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 5) {
                              return "Please enter a valid  address";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            hintText: 'Shipping address',
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AuthButton(
                    buttonText: 'Sign up',
                    fct: () {
                      _submitFormOnRegister();
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: 'Already a user?',
                            style: getbodyStyle(),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' Sign in',
                                  style:
                                      getTitleStyle(color: AppColors.primary),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacementNamed(
                                          context, LoginScreen.routeName);
                                    }),
                            ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

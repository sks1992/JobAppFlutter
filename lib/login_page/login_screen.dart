import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_clone_app_flutter/forget_password_screen/forget_password_screen.dart';
import 'package:job_clone_app_flutter/services/global_variables.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  //Animation<double> − interpolate values between two decimal number
  late Animation<double> _animation;

  //AnimationController − Special Animation object to control the animation itself.
  // It generates new values whenever the application is ready for a new frame. It
  // supports linear based animation and the value starts from 0.0 to 1.0
  late AnimationController _animationController;

  final _loginFormKey = GlobalKey<FormState>();
  final FocusNode _passFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = false;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: loginUrlImage,
              placeholder: (context, url) => Image.asset(
                "assets/images/wallpaper.jpg",
                fit: BoxFit.fill,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              alignment: FractionalOffset(_animation.value, 0),
            ),
            Container(
              color: Colors.black54,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 80,
                ),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 80, right: 80),
                      child: Image.asset("assets/images/login.png"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passFocusNode),
                            keyboardType: TextInputType.text,
                            controller: _emailController,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return "Please Enter a Valid Email address";
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passFocusNode),
                            keyboardType: TextInputType.text,
                            controller: _passwordController,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 5) {
                                return "Please Enter a Password more than 7 characters";
                              }
                              return null;
                            },
                            obscureText: !_obscureText,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: _obscureText
                                      ? const Icon(
                                          Icons.visibility,
                                          color: Colors.white,
                                        )
                                      : const Icon(
                                          Icons.visibility_off,
                                          color: Colors.white,
                                        )),
                              labelText: "Password",
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>const ForgetPasswordScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Forget Password",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photogenie_app/resources/auth_methods.dart';
import 'package:photogenie_app/screens/sign_up2_screen.dart';
import 'package:photogenie_app/widgets/text_field_input.dart';
import 'package:photogenie_app/screens/sign_in_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:date_format/date_format.dart';

import '../widgets/text_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  late final VideoPlayerController _videoPlayerController;
  late DateTime birthday = DateTime.now();

  bool _isLoading = false;

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        firstname: _firstnameController.text,
        lastname: _lastnameController.text,
        email: _emailController.text,
        birthday: _birthdayController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text);
    if (res == 'success') {
      Get.off(() => const SignUp2());
    } else {
      Get.snackbar('about signup', res,
          backgroundColor: const Color(0xff0F0E17),
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            'SignUp Failed',
            style: TextStyle(
                color: Color.fromARGB(255, 231, 224, 233),
                fontWeight: FontWeight.bold),
          ),
          colorText: const Color(0xffFFFFFE));
    }
    setState(() {
      _isLoading = false;
    });
  }

  _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff0F0E17),
              onPrimary: Color(0xffAE2A58),
              onSurface: Color(0xff0F0E17),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xffAE2A58),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      String formatedDate = formatDate(pickedDate, [yyyy, '-', mm, '-', dd]);
      setState(() {
        _birthdayController.text = formatedDate;
      });
    }
  }

  @override
  void initState() {
    _videoPlayerController =
        VideoPlayerController.asset('assets/video/bgvideo.mp4')
          ..initialize().then((context) {
            _videoPlayerController.play();
            _videoPlayerController.setLooping(true);
            setState(() {});
          });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _birthdayController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F0E17),
      resizeToAvoidBottomInset: false,
      body: Stack(children: <Widget>[
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              height: _videoPlayerController.value.size.height,
              width: _videoPlayerController.value.size.width,
              child: VideoPlayer(_videoPlayerController),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                'assets/images/logo.png',
                width: 150,
                height: 210,
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 40,
                child: TextFieldInput(
                  hintText: 'Firstname',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _firstnameController,
                  icon: 'Person',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 40,
                child: TextFieldInput(
                  hintText: 'Lastname',
                  textInputType: TextInputType.text,
                  textEditingController: _lastnameController,
                  icon: 'Person',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 40,
                child: TextFieldInput(
                  hintText: 'Your email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                  icon: 'email',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 40,
                child: TextField(
                  style: const TextStyle(color: Color(0xffFFFFFE)),
                  controller: _birthdayController,
                  decoration: InputDecoration(
                    hintText: 'Your birthday',
                    hintStyle:
                        const TextStyle(color: Color(0xffa1a1a1), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: const Color(0xff0F0E17),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        'assets/icons/calendar.png',
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  readOnly: true,
                  onTap: () {
                    _selectDate(context);
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 40,
                child: TextFieldInput(
                  hintText: 'Your password',
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: true,
                  icon: 'password',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 40,
                child: TextFieldInput(
                  hintText: 'Confirm password',
                  textInputType: TextInputType.text,
                  textEditingController: _confirmPasswordController,
                  isPass: true,
                  icon: 'password',
                ),
              ),
              const SizedBox(
                height: 40,
              ),

              //sign up button
              ButtonText(
                function: signUpUser,
                text: 'Sign Up',
                isLoading: _isLoading,
                width: 300,
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account ?",
                    style: TextStyle(color: Color(0xffFFFFFE)),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Get.to(const SignInScreen()),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                          color: Color(0xffAE2A58),
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}

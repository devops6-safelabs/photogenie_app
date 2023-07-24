import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photogenie_app/resources/auth_methods.dart';
import 'package:photogenie_app/screens/home_screen.dart';
import 'package:photogenie_app/screens/sign_up_screen.dart';
import 'package:photogenie_app/widgets/text_button.dart';
import 'package:photogenie_app/widgets/text_field_input.dart';
import 'package:video_player/video_player.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final VideoPlayerController _videoPlayerController;
  bool _isLoading = false;

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
    _videoPlayerController.dispose();
  }

  //loginUser
  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      Get.offAll(() => const HomePage());
    } else {
      Get.snackbar('about login', res,
          backgroundColor: const Color(0xff0F0E17),
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            'Login Failed',
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
                height: 70,
              ),
              Image.asset(
                'assets/images/logo.png',
                width: 170,
                height: 230,
              ),
              const SizedBox(
                height: 60,
              ),
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
                icon: 'email',
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
                icon: 'password',
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Forgot Password ?',
                style: TextStyle(color: Color(0xffFFFFFE)),
              ),
              const SizedBox(
                height: 30,
              ),
              //Login button
              ButtonText(
                function: loginUser,
                text: 'Sign In',
                isLoading: _isLoading,
                width: 300,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                height: 42,
                child: ElevatedButton.icon(
                  onPressed: () {
                    AuthMethods().signInWithGoogle();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFFFFFE),
                  ),
                  icon: Image.asset('assets/icons/gmail.png'),
                  label: const Text(
                    'Sign In with Google',
                    style: TextStyle(color: Color(0xff0D0319)),
                  ),
                ),
              ),

              const SizedBox(
                height: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account ?",
                    style: TextStyle(color: Color(0xffFFFFFE)),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Get.to(const SignUpScreen()),
                    child: const Text(
                      'Sign Up',
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

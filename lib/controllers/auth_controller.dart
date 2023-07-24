// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:photogenie_app/screens/home_screen.dart';
// import 'package:photogenie_app/screens/sign_in_screen.dart';

// class AuthController extends GetxController {
//   //AuthController accesible everywhere
//   static AuthController instance = Get.find();

//   late Rx<User?> _user;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final userv = FirebaseAuth.instance.currentUser;

//   @override
//   void onReady() {
//     _user = Rx<User?>(_auth.currentUser);
//     //notified the user
//     _user.bindStream(_auth.userChanges());
//     super.onReady();
//     ever(_user, _initialScreen);
//   }

//   _initialScreen(User? user) {
//     if (user == null) {
//       Get.offAll(() => const SignInScreen());
//     }
//     //  else if (userv?.emailVerified ?? false) {
//     //   Get.offAll(() => const HomePage());
//     // }
//     else {
//       Get.offAll(() => const HomePage());
//     }
//   }
// }

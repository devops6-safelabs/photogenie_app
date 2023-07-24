import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:photogenie_app/models/user_model.dart' as model;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:photogenie_app/screens/home_screen.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? verificationId;

  //sign up user
  Future<String> signUpUser(
      {required String firstname,
      required String lastname,
      required String email,
      required String birthday,
      required String password,
      required String confirmPassword,
      context}) async {
    String res = 'Some error occured';

    try {
      if (firstname.isNotEmpty ||
          lastname.isNotEmpty ||
          email.isNotEmpty ||
          birthday.isNotEmpty ||
          password.isNotEmpty ||
          confirmPassword.isNotEmpty) {
        //register user
        if (password.trim() == confirmPassword.trim()) {
          UserCredential cred = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          model.User user = model.User(
            firstname: firstname,
            lastname: lastname,
            email: email,
            uid: cred.user!.uid,
            birthday: birthday,
          );
          // add user to database
          res = 'success';
          await _firestore
              .collection('users')
              .doc(cred.user!.uid)
              .set(user.toJson());
        }
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = 'Incorect informations';
    }
    return res;
  }

//loging an user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = 'Email or password is wrong';
    }
    return res;
  }

  //sign in with google
  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //verification phone number
  phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: '+212 687779091',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential).then((value) {
            () => Get.offAll(const HomePage());
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('Phone number not valid');
          } else {
            //
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          this.verificationId = verificationId;
          String smsCode='123456';
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);

          // Sign the user in (or link) with the credential
          await _auth.signInWithCredential(credential);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        });
  }

//Sign out
  signOut(context) async {
    await _auth.signOut();
  }
}

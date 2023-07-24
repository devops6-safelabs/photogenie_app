import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photogenie_app/screens/confirm_phone_number.dart';
import 'package:photogenie_app/widgets/text_button.dart';
import 'package:video_player/video_player.dart';
import '../widgets/text_field_input.dart';

class SignUp2 extends StatefulWidget {
  const SignUp2({super.key});

  @override
  State<SignUp2> createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late final VideoPlayerController _videoPlayerController;
  final bool _isLoading = false;

  String selectCountry = 'Select your country';
  String codeCountry = '212';

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
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  countrySelect() {
    showCountryPicker(
        context: context,
        favorite: <String>['MA', 'FR', 'US'],
        onSelect: (Country country) {
          setState(() {
            selectCountry = country.displayNameNoCountryCode.toString();
            codeCountry = country.phoneCode.toString();
          });
        });
  }

  updateUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'username': _usernameController.text,
      'country': selectCountry,
      'phone': '+$codeCountry ${_phoneController.text}'
    });
    Get.off(() => const ConfirmNumber());
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
                height: 80,
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
                hintText: 'Your username',
                textInputType: TextInputType.emailAddress,
                textEditingController: _usernameController,
                icon: 'Person',
              ),
              const SizedBox(
                height: 18,
              ),

              //text field for country
              GestureDetector(
                onTap: countrySelect,
                child: SizedBox(
                  width: double.infinity,
                  height: 42.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: const Color(0xff0F0E17),
                        border: Border.all(width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Image.asset('assets/icons/Country.png'),
                          const SizedBox(
                            width: 14,
                          ),
                          Text(selectCountry,
                              style: const TextStyle(
                                color: Color(0xffa1a1a1),
                                fontSize: 14,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              GestureDetector(
                child: SizedBox(
                  width: double.infinity,
                  height: 42.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: const Color(0xff0F0E17),
                        border: Border.all(width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Image.asset('assets/icons/Phone.png'),
                          const SizedBox(
                            width: 14,
                          ),
                          Text('+$codeCountry',
                              style: const TextStyle(
                                color: Color(0xffa1a1a1),
                                fontSize: 14,
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]"))
                              ],
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              style: const TextStyle(
                                color: Color(0xffa1a1a1),
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Your phone number',
                                  hintStyle: TextStyle(
                                    color: Color(0xffa1a1a1),
                                    fontSize: 14,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              //confirm phone number button
              ButtonText(
                  function: (){
                    updateUser(); 
                  },
                  text: 'Confirm phone number',
                  isLoading: _isLoading,
                  width: 240)
            ],
          ),
        ),
      ]),
    );
  }
}

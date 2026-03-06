import 'dart:ui';

import 'package:flame/components/button.dart';
import 'package:flame/components/text_field.dart';
import 'package:flutter/material.dart';


class loginPage extends StatefulWidget {
  final Function()? onTap;
  const loginPage({super.key,required this.onTap});

  @override
  State<loginPage> createState() => _LoginPageState();

}
class _LoginPageState extends State<loginPage>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // final hintText = "Enter your email";
  // final obscureText = ;


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.grey ,

      body: SafeArea(

        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Logo
                Image.asset(
                  'images/FLAME_LOGO.png',
                  width: 100,
                  height:100,
                ),

                const SizedBox(height: 50),
                Text(
                    "Pass the FLAME"
                ),
                const SizedBox(height: 25),



                //Email
                MyTextField(controller: emailController
                    , hintText: 'EMAIL'
                    , obscureText: false
                ),
                const SizedBox(height: 10),
                MyTextField(controller: passwordController
                    , hintText: 'PASSWORD'
                    , obscureText: true
                ),
                const SizedBox(height: 10),

                //Password

                //Sign in btn
                MyButton(onTap: () {}, text: 'Sign in'),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),



                // reset password

                // icons

              ],
            ),
          ),
        ),
      ),
    );
  }
}import 'dart:ui';

import 'package:flame/components/button.dart';
import 'package:flame/components/text_field.dart';
import 'package:flutter/material.dart';


class registerPage extends StatefulWidget{
  final Function()? onTap;
  const registerPage({super.key, required this.onTap});

  @override
  State<registerPage> createState() => _RegisterPageState();
}
class _RegisterPageState extends State<registerPage>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // final hintText = "Enter your email";
  // final obscureText = ;
  final confirmPasswordController = TextEditingController();



  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.grey ,

      body: SafeArea(

        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Logo
                Image.asset(
                  'images/FLAME_LOGO.png',
                  width: 175,
                  height:175,
                ),

                //const SizedBox(height: 5),
                Text(
                    "Let's create a new account for you"
                ),
                const SizedBox(height: 25),



                //Email
                MyTextField(controller: emailController
                    , hintText: 'EMAIL'
                    , obscureText: false
                ),
                const SizedBox(height: 20),
                //Password

                MyTextField(controller: passwordController
                    , hintText: 'PASSWORD'
                    , obscureText: true
                ),
                const SizedBox(height: 20),

                MyTextField(controller: confirmPasswordController
                    , hintText: 'Confirm PASSWORD'
                    , obscureText: true
                ),
                const SizedBox                //Password
                  (height: 80),


                //Sign in btn
                MyButton(onTap: () {}, text: 'Sign up'),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already Have an account?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('login Page',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),



                // reset password

                // icons

              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget{
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField(
      {
        super.key,
        required this.controller,
        required this.hintText,
        required this.obscureText,

      });
  @override
  Widget build(BuildContext){
    return TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          )
          ,
        )

    );




  }


}

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget{
  final Function()? onTap ;
  final String text;
  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
  });
  @override
  Widget build(BuildContext){
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ) ,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );

  }



}




import 'package:flutter/material.dart';
import 'package:flame/Pages/loginPage.dart';
import 'package:flame/Pages/registerPage.dart ';
class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}
class _LoginOrRegisterState extends State<LoginOrRegister> {
  //Intialley , show the login page
  bool showLoginPage = true;
//toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return loginPage(onTap: togglePages);
    }
    else {
      return registerPage(onTap: togglePages);
    }

  }
}

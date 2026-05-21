import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;

  const RegisterPage({
    Key? key,
    required this.showLoginPage,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _moduleController = TextEditingController();
  final _rollnoController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _moduleController.dispose();
    _rollnoController.dispose();
    super.dispose();
  }

  // SIGN UP METHOD
  Future signUp() async {

    try {

      // create user in firebase auth
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // save extra user details in firestore
      await addUserDetails(
        userCredential.user!.uid,
        _nameController.text.trim(),
        _rollnoController.text.trim(),
        _moduleController.text.trim(),
        _phoneController.text.trim(),
        _emailController.text.trim(),
      );

      // success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User Registered Successfully"),
        ),
      );

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Authentication Error"),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

    }
  }

  // ADD USER DETAILS TO FIRESTORE
  Future addUserDetails(
      String uid,
      String name,
      String rollno,
      String module,
      String phone,
      String email,
      ) async {

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
      'name': name,
      'rollno': rollno,
      'module': module,
      'phone': phone,
      'email': email,
      'createdAt': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(

        child: Center(

          child: SingleChildScrollView(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 20),

                // title
                const Text(
                  'Hello There!',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Register below with your details!',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 25),

                // name field
                buildTextField(
                  controller: _nameController,
                  hintText: 'Name',
                ),

                const SizedBox(height: 15),

                // roll no
                buildTextField(
                  controller: _rollnoController,
                  hintText: 'Roll Number',
                ),

                const SizedBox(height: 15),

                // module
                buildTextField(
                  controller: _moduleController,
                  hintText: 'Module Code',
                ),

                const SizedBox(height: 15),

                // phone
                buildTextField(
                  controller: _phoneController,
                  hintText: 'Contact Number',
                ),

                const SizedBox(height: 15),

                // email
                buildTextField(
                  controller: _emailController,
                  hintText: 'Email',
                ),

                const SizedBox(height: 15),

                // password
                buildTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // sign up button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),

                  child: GestureDetector(

                    onTap: signUp,

                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),

                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: const Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // login redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Text(
                      'Already a member?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 5),

                    GestureDetector(
                      onTap: widget.showLoginPage,

                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // REUSABLE TEXTFIELD WIDGET
  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
  }) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),

      child: Container(

        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),

        child: Padding(
          padding: const EdgeInsets.only(left: 20),

          child: TextField(
            controller: controller,
            obscureText: obscureText,

            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final Authservice _auth = Authservice();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text('Sign In to Brew Crew'),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              widget.toggleView();
            }, 
            icon: Icon(Icons.person), 
            label: Text('Register')
          )],
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText:'Email'),
                onChanged: (val){
                  setState(() => email = val);
                },
                validator: (val) => val.isEmpty ? 'Please Enter an Email!' : null,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText:'Password'),
                obscureText: true,
                onChanged: (val){
                  setState(() => password = val);
                },
                validator: (val) => val.length<6 ? 'Please Enter a Password(6 or more char)!' : null,
              ),
              SizedBox(height: 20.0,),
              RaisedButton(
                color:Colors.pink[400],
                onPressed: () async {
                   if(_formKey.currentState.validate()){
                     setState(() => loading = true );
                     dynamic result = await _auth.signInWithEmailPass(email, password);
                    if(result == null){
                      setState(() {
                         error = 'Could not SignIn with this Credentials!';
                         loading = false;
                         });
                    }
                  }
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
                  ),
              ),
              SizedBox(height:20.0),
              Text(
                error,
                style: TextStyle(
                  color:Colors.red,
                  fontSize: 14.0
                ),
              )
            ]
          ),
        ),
      ),

    );
  }
}
import 'package:flutter/material.dart';
import 'package:pfa_flutter/logic/auth/auth_bloc.dart';

import 'ProfileImageWidget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: FutureBuilder<String?>(
          future: AuthBloc.getIdFromToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProfileImageWidget(userId: snapshot.data!, radius: 50.0, borderColor: Colors.white,),
                  SizedBox(height: 20),
                  Text('User ID: ${snapshot.data}'),
                ],
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  const HomePage({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Wrap(
            // crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed('/bloc/example/');
                    }, 
                    child: Text('Example')
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed('/bloc/example/freezed');
                    }, 
                    child: Text('Example Freezed')
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed('/contacts/list');
                    }, 
                    child: Text('Contact')
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed('/contacts/cubit/list');
                    }, 
                    child: Text('Contact Cubit')
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
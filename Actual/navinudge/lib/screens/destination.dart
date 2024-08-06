import 'package:flutter/material.dart';
import 'directions.dart';

class DestinationSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Destination Selection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose your intended destination:',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Input your destination',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Favorites:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: 300,
                child: FilledButton.icon(
                  onPressed: (){
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>Directions())
                    );
                  },
                  icon: const Icon(Icons.home_filled),
                  label: const Text('Home'))
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: 300,
                child: FilledButton.icon(
                  onPressed: (){},
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Market'))
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: 300,
                child: FilledButton.icon(
                  onPressed: (){},
                  icon: const Icon(Icons.school),
                  label: const Text('School'))
              )
            ],
          ),
        ),
      ),
    );
  }
}


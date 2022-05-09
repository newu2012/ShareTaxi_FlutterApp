import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/map_controller.dart';

class UserAddressesColumn extends StatelessWidget {
  const UserAddressesColumn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            height: 32,
            child: TextFormField(
              readOnly: true,
              initialValue: Provider.of<MapController>(context, listen: false)
                  .fromPointAddress,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 15.0),
                prefixIcon: SizedBox(
                  width: 64,
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).primaryColor,
                      ),
                      const Text('От'),
                    ],
                  ),
                ),
                prefixIconColor: const Color.fromARGB(255, 111, 108, 217),
              ),
            ),
          ),
          SizedBox(
            height: 32,
            child: TextFormField(
              readOnly: true,
              initialValue: Provider.of<MapController>(context, listen: false)
                  .toPointAddress,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 15.0),
                prefixIcon: SizedBox(
                  width: 64,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color.fromRGBO(255, 174, 3, 100),
                      ),
                      const Text('До'),
                    ],
                  ),
                ),
                prefixIconColor: const Color.fromARGB(255, 255, 174, 3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

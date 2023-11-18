import 'package:flutter/material.dart';



class CustomTabBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Align(
      child: Material(
        elevation: 2,
        child: DefaultTabController(
          length: 3, // Adjust the length based on the number of tabs

          child: Container(
            color: Colors.white,
            child: const TabBar(
              tabs: [
                Tab(text: 'Kurikulum'),
                Tab(text: 'Ikhtisar'),
                Tab(text: 'Lampiran'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50.0; // Adjust the height as needed

  @override
  double get minExtent => 50.0; // Adjust the height as needed

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
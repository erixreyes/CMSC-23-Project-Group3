import 'package:cmsc_23_project_group3/pages/views/organization/organization_donations.dart';
import 'package:cmsc_23_project_group3/pages/views/organization/organization_drives.dart';
import 'package:cmsc_23_project_group3/pages/views/organization/organization_home.dart';
import 'package:cmsc_23_project_group3/pages/views/organization/organization_profile.dart';
import 'package:cmsc_23_project_group3/providers/auth_provider.dart';

import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class OrganizationView extends StatefulWidget {
  const OrganizationView({super.key});

  @override
  State<OrganizationView> createState() => _OrganizationViewState();
}

class _OrganizationViewState extends State<OrganizationView> {
  int _currPageIndex = 0;
  final _pages = [
    const OrganizationHome(),
    const OrganizationDonations(),
    const OrganizationDrives(),
    const OrganizationProfile()
  ];
  final _pageController = PageController();

  final approvedTabs = [
    const GButton(icon: Icons.home_outlined, text: 'Home'),
    const GButton(icon: Icons.healing_outlined, text: 'Donations'),
    const GButton(icon: Icons.handshake_outlined, text: 'Drives'),
    const GButton(icon: Icons.person_outline_rounded, text: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserAuthProvider>().getApprovalStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool? isApproved = context.watch<UserAuthProvider>().userApprovalStatus;

    if (isApproved == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      bottomNavigationBar: !isApproved ? null : Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.grey.withOpacity(0.3),
            ),
          ],
        ),
        child: GNav(
          haptic: true,
          tabBorderRadius: 50,
          gap: 5,
          color: Styles.darkerGray,
          activeColor: Styles.mainBlue,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          selectedIndex: _currPageIndex,
          onTabChange: (index) {
            setState(() {
              _currPageIndex = index;
              _pageController.animateToPage(
                _currPageIndex,
                duration: const Duration(milliseconds: 250),
                curve: Curves.linear,
              );
            });
          },
          tabs: isApproved ? approvedTabs : [approvedTabs[3]],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currPageIndex = index;
          });
        },
        children: isApproved ? _pages : [_pages[3]],
      ),
    );
  }
}

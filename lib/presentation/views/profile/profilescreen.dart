import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/presentation/provider/profile_provider.dart';
import 'package:untitled3/presentation/views/cart/carts_screen.dart';
import 'package:untitled3/presentation/views/favouriteScreen/favourite_screen.dart';
import 'package:untitled3/presentation/views/order/orderscreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4; // Set initial index to 'Profile'

  @override
  void initState() {
    super.initState();
    // Fetch profile data when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (index == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const CartsScreen()));
    } else if (index == 2) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const OrderScreen()));
    } else if (index == 3) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FavoriteScreen()));
    } else if (index != 4) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Are you sure?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
                  ),
                  children: const [
                    TextSpan(
                      text: 'Are you sure you want to ',
                    ),
                    TextSpan(
                      text: 'delete your account permanently?',
                      style: TextStyle(color: Color(0xFFEF233C)),
                    ),
                    TextSpan(
                      text:
                          ' This will erase all your saved data, order history, and personalized recommendations. Click "',
                    ),
                    TextSpan(
                      text: 'Delete',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: '" to proceed, or "',
                    ),
                    TextSpan(
                      text: 'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: '" to keep your account and data intact.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Updated Color
                        foregroundColor: Colors.white, // Updated Text Color
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle delete logic here
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0x12FF0000), // Updated Color
                        foregroundColor: const Color(0xFFEF233C), // Updated Text Color
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0, // Flat button look
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Yes, Delete it'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Consumer<ProfileProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.error != null) {
                return Center(child: Text('Error: ${provider.error}'));
              }

              if (provider.profile == null) {
                // This can happen if the fetch call hasn't completed yet or failed silently
                return const Center(child: Text('No profile data available. Pull to refresh.'));
              }

              final profile = provider.profile!;

              return Column(
                children: [
                  // -- New Header --
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Profile',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Adjusted Space

                  // -- New Profile Info Card --
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30, // Adjusted Radius
                          backgroundColor: const Color(0xFFEEF0F6),
                          backgroundImage: profile.avatarUrl.isNotEmpty
                              ? NetworkImage(profile.avatarUrl)
                              : null,
                          child: profile.avatarUrl.isEmpty
                              ? const Icon(Icons.person, size: 30, color: Colors.grey)
                              : null,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      profile.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 20),
                                    onPressed: () {},
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                              Text(
                                profile.email,
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile.phone,
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15), // Adjusted Space

                  // -- Menu Items --
                  _buildProfileMenuItem(text: 'Account Settings', onTap: () {}),
                  _buildProfileMenuItem(text: 'Change Password', onTap: () {}),
                  _buildProfileMenuItem(text: 'Language', onTap: () {}),
                  _buildProfileMenuItem(text: 'Terms & Conditions', onTap: () {}),
                  _buildProfileMenuItem(text: 'Privacy Policy', onTap: () {}),
                  _buildProfileMenuItem(text: 'Help & Support', onTap: () {}),
                  _buildProfileMenuItem(text: 'Rate Our App', onTap: () {}),
                  const SizedBox(height: 10),
                  _buildProfileMenuItem(
                    text: 'Logout',
                    color: Colors.red,
                    onTap: () => _showLogoutBottomSheet(context),
                  ),

                  const Spacer(), // This will now work correctly
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false, // Hide labels
        showUnselectedLabels: false, // Hide labels
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '', // Empty label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildProfileMenuItem(
      {required String text, Color? color, VoidCallback? onTap}) {
    final bool isLogout = text == 'Logout';
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0), // Adjusted Margin
      elevation: 0,
      color: const Color(0xFFEEF0F6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true, // Makes the ListTile more compact
        title: Text(text,
            style: TextStyle(
                fontSize: 14, // Updated font size
                fontWeight: FontWeight.w500, // Updated font weight
                color: color ?? Colors.black)),
        trailing: isLogout
            ? null
            : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vibe_connect/features/app_bar/app_bar.dart';
import 'package:vibe_connect/features/app_bar/app_drawer.dart';
import 'package:vibe_connect/utils/size_config.dart';
import 'presentation/cubits/profile_cubit.dart';
import 'presentation/cubits/profile_states.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Fetch user profile when page loads
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      context.read<ProfileCubit>().fetchUserProfile(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: const Color(0xFF58A0C8),
      appBar: CustomAppBar(title: "Profile"),
      drawer: const AppDrawer(),
      body: BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF8A56E2),
              ),
            );
          } else if (state is ProfileLoaded) {
            return _buildProfileContent(state.profile, context);
          } else if (state is ProfileNotFound) {
            return _buildProfileNotFound();
          } else if (state is ProfileError) {
            return _buildErrorState(state.message);
          } else {
            return const Center(
              child: Text(
                'No profile data',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileContent(profile, BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.w),
            child: Row(
              children: [
                // Profile Image
                SizedBox(
                  width: 80.w,
                  height: 80.w,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile11.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                // Name and Email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name.isNotEmpty ? profile.name : 'No Name',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.inversePrimary,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      if (profile.email != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          profile.email,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),

          // Plan and Top-ups Section wrapped in background container
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary,
              borderRadius: BorderRadius.circular(16.w),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                children: [
                  _buildPlanCard(theme),
                  SizedBox(height: 16.h),
                  _buildTopUpsCard(theme),
                ],
              ),
            ),
          ),
          SizedBox(height: 15.h),

          // Refer & Earn Section
          _buildReferEarnCard(),
          SizedBox(height: 32.h),

          // // Other Section
          // Text(
          //   'Other',
          //   style: TextStyle(
          //     fontSize: 20.sp,
          //     fontWeight: FontWeight.w600,
          //     color: theme.colorScheme.inversePrimary,
          //     fontFamily: 'Urbanist',
          //   ),
          // ),
          // SizedBox(height: 16.h),

          // // // Other Options
          // // _buildOtherOption(
          //   Icons.settings,
          //   'Settings',
          //   onTap: () {},
          //   theme: theme,
          // ),
          // _buildOtherOption(Icons.receipt, 'Invoice History', theme: theme),
          // _buildOtherOption(Icons.description, 'Terms & Conditions', theme: theme),
          // _buildOtherOption(Icons.privacy_tip, 'Privacy Policy', theme: theme),
          // _buildOtherOption(Icons.feedback, 'Feedback', theme: theme),
        ],
      ),
    );
  }

  Widget _buildPlanCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star,
                color: Color(0xFF8A56E2),
                size: 20.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'Plan : Starter (Premium)',
                style: TextStyle(
                  color: theme.colorScheme.inversePrimary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Urbanist',
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Renews on 12 July 2025',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Urbanist',
            ),
          ),
          SizedBox(height: 16.h),
          Opacity(
            opacity: 1,
            child: Container(
              width: 84.w,
              height: 32.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.w),
                gradient: LinearGradient(
                  colors: [Color(0xFF9066B8), Color(0xFFB089F1)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              padding: EdgeInsets.fromLTRB(12.w, 6.h, 12.w, 6.h),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.w),
                  onTap: () {
                    // Handle manage button
                  },
                  child: Center(
                    child: Text(
                      'Manage',
                      style: TextStyle(
                        color: Color(0xFF0D0D12),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Urbanist',
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopUpsCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.add,
                color: Color(0xFF8A56E2),
                size: 20.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'Add Tops-ups',
                style: TextStyle(
                  color: theme.colorScheme.inversePrimary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Urbanist',
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Purchase extra credits for more creations',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Urbanist',
            ),
          ),
          SizedBox(height: 16.h),
          Opacity(
            opacity: 1,
            child: Container(
              width: 88.w,
              height: 32.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.w),
                gradient: LinearGradient(
                  colors: [Color(0xFF9066B8), Color(0xFFB089F1)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              padding: EdgeInsets.fromLTRB(12.w, 6.h, 12.w, 6.h),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.w),
                  onTap: () {
                    // Handle manage button
                  },
                  child: Center(
                    child: Text(
                      'Buy More',
                      style: TextStyle(
                        color: Color(0xFF0D0D12),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Urbanist',
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferEarnCard() {
    return Container(
      width: 364.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
        gradient: LinearGradient(
          colors: [Color(0xFF6033B0), Color(0xFF8752D8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Circular icon background
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Color(0xFF6A3FB8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  'Refer & Earn',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Urbanist',
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'Invite your friends and earn rewards!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Urbanist',
                fontStyle: FontStyle.normal,
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: 89.w,
              height: 32.h,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(1),
                  foregroundColor: Color(0xFF0D0D12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                  padding: EdgeInsets.fromLTRB(12.w, 6.h, 12.w, 6.h),
                ),
                child: Center(
                  child: Text(
                    'Refer',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Urbanist',
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildOtherOption(IconData icon, String title, {VoidCallback? onTap, required ThemeData theme}) {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 12.h),
  //     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
  //     decoration: BoxDecoration(
  //       color: theme.colorScheme.secondary,
  //       borderRadius: BorderRadius.circular(8.w),
  //     ),
  //     child: Material(
  //       color: Colors.transparent,
  //       child: InkWell(
  //         borderRadius: BorderRadius.circular(8.w),
  //         onTap: onTap,
  //         child: Row(
  //           children: [
  //             Icon(
  //               icon,
  //               color: theme.colorScheme.inversePrimary,
  //               size: 20.w,
  //             ),
  //             SizedBox(width: 12.w),
  //             Expanded(
  //               child: Text(
  //                 title,
  //                 style: TextStyle(
  //                   color: theme.colorScheme.inversePrimary,
  //                   fontSize: 16.sp,
  //                   fontWeight: FontWeight.w500,
  //                   fontFamily: 'Urbanist',
  //                 ),
  //               ),
  //             ),
  //             Icon(
  //               Icons.chevron_right,
  //               color: theme.colorScheme.inversePrimary,
  //               size: 20.w,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildProfileNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 64.w,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'Profile Not Found',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFamily: 'Urbanist',
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'No profile data found for this user.',
            style: TextStyle(
              fontSize: 16.sp,
              color: Color(0xFF9E9E9E),
              fontWeight: FontWeight.w400,
              fontFamily: 'Urbanist',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.w,
            color: Colors.red[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'Error Loading Profile',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.red,
              fontFamily: 'Urbanist',
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
              color: Color(0xFF9E9E9E),
              fontWeight: FontWeight.w400,
              fontFamily: 'Urbanist',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              final userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId != null) {
                context.read<ProfileCubit>().fetchUserProfile(userId);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8A56E2),
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Retry',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

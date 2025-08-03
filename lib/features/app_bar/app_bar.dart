import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: SafeArea(
        child: Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.inversePrimary,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Urbanist',
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            SizedBox(width: 9.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      color: theme.colorScheme.inversePrimary,
                      size: 13.0,
                    ),
                    const SizedBox(width: 2.0),
                    Text(
                      "Guest",
                      style: TextStyle(
                        color: theme.colorScheme.inversePrimary,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    Container(
                      height: 15.0,
                      width: 1.0,
                      margin: const EdgeInsets.symmetric(horizontal: 6.0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.inversePrimary.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(1.0),
                      ),
                    ),
                    Icon(
                      Icons.attach_money_rounded,
                      color: theme.colorScheme.inversePrimary,
                      size: 13.0,
                    ),
                    const SizedBox(width: 1.0),
                    Text(
                      "50 Credits",
                      style: TextStyle(
                        color: theme.colorScheme.inversePrimary,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70.0);
} 
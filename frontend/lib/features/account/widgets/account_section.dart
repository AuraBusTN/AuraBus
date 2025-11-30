import 'package:flutter/material.dart';

class AccountSection extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget? child;

  const AccountSection({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          if (isExpanded)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(title, style: Theme.of(context).textTheme.titleMedium),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.chevron_right,
            ),
            onTap: onTap,
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: isExpanded && child != null
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: child,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

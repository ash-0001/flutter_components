import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> tabs;

  const CustomTabBar({Key? key, required this.tabs}) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int selectedIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double padding = constraints.maxWidth * 0.02;
        return Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: padding),
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: padding,
            runSpacing: padding,
            children: List.generate(widget.tabs.length, (index) {
              return _buildTabItem(widget.tabs[index], index, padding);
            }),
          ),
        );
      },
    );
  }

  Widget _buildTabItem(String text, int index, double padding) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onTabTapped(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding * 2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: Colors.blue, width: 2.0)
              : Border.all(color: Colors.transparent),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Custom Tab Bar Example')),
      body: Column(
        children: [
          CustomTabBar(
            tabs: ['Basic', 'Integrations', 'Team', 'Billing', 'Advanced'],
          ),
          Expanded(child: Container()), // Placeholder for content
        ],
      ),
    ),
  ));
}

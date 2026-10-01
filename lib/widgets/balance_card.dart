import 'package:flutter/material.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => balanceCardState();
}

class balanceCardState extends State<BalanceCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF173D30),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF173D30).withOpacity(0.18),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Balance de septiembre',
            style: TextStyle(color: Color(0xFFB7C8C0), fontSize: 13),
          ),
          const SizedBox(height: 10),
          const Text(
            '\$ 18.420,00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 13),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 7,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFB7F25C).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '↑ 12,8%',
                  style: TextStyle(
                    color: Color(0xFFC7FA7B),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Text(
                'frente al mes anterior',
                style: TextStyle(color: Color(0xFFA8BBB3), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Divider(color: Colors.white.withOpacity(0.1), height: 1),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                child: _BalanceItem(
                  icon: Icons.arrow_upward_rounded,
                  label: 'Ingresos',
                  value: '\$ 24.850',
                  color: Color(0xFFB7F25C),
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: _BalanceItem(
                  icon: Icons.arrow_downward_rounded,
                  label: 'Gastos',
                  value: '\$ 6.430',
                  color: Color(0xFFFFB49F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceItem extends StatelessWidget {
  const _BalanceItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Color(0xFF9FB3AA), fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

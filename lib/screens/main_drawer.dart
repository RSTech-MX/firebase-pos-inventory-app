import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
    this.onProfile,
    this.onSales,
    this.onPurchases,
    this.onInventory,
    this.onNotes,
    this.onSettings,
  });

  final VoidCallback? onProfile;
  final VoidCallback? onSales;
  final VoidCallback? onPurchases;
  final VoidCallback? onInventory;
  final VoidCallback? onNotes;
  final VoidCallback? onSettings;

  static const _dark = Color(0xFF0D2B21);
  static const _lime = Color(0xFFB7F25C);
  static const _muted = Color(0xFFB2C2BC);

  void _select(BuildContext context, VoidCallback? action) {
    Navigator.pop(context);
    if (action != null) {
      Future<void>.delayed(const Duration(milliseconds: 220), action);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      elevation: 0,
      backgroundColor: _dark,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    _DrawerLogo(),
                    SizedBox(width: 12),
                    Text(
                      'Nexo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _DrawerItem(
                icon: Icons.bar_chart_rounded,
                label: 'Resumen',
                selected: true,
                onTap: () => _select(context, null),
              ),
              _DrawerItem(
                icon: Icons.attach_money_rounded,
                label: 'Perfil',
                onTap: () => _select(context, onProfile),
              ),
              _DrawerItem(
                icon: Icons.attach_money_rounded,
                label: 'Ventas',
                onTap: () => _select(context, onSales),
              ),
              _DrawerItem(
                icon: Icons.shopping_cart_outlined,
                label: 'Compras',
                onTap: () => _select(context, onPurchases),
              ),
              _DrawerItem(
                icon: Icons.inventory_2_outlined,
                label: 'Inventario',
                onTap: () => _select(context, onInventory),
              ),
              _DrawerItem(
                icon: Icons.note_alt_outlined,
                label: 'Notas',
                onTap: () => _select(context, onNotes),
              ),
              const Spacer(),
              _DrawerItem(
                icon: Icons.settings_outlined,
                label: 'Configuración',
                onTap: () => _select(context, onSettings),
              ),
              const SizedBox(height: 18),
              Container(height: 1, color: const Color(0xFF2E493F)),
              const SizedBox(height: 24),
              const Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFFE7B5FA),
                    child: Text(
                      'AM',
                      style: TextStyle(
                        color: Color(0xFF57346E),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Andrea Méndez',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Administradora',
                          style: TextStyle(
                            color: Color(0xFF71B091),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerLogo extends StatelessWidget {
  const _DrawerLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: MainDrawer._lime,
        borderRadius: BorderRadius.circular(11),
      ),
      child: const Text(
        'N',
        style: TextStyle(
          color: MainDrawer._dark,
          fontSize: 21,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? MainDrawer._dark : MainDrawer._muted;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? MainDrawer._lime : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          splashColor: Colors.white.withOpacity(0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: foreground, size: 23),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 16,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

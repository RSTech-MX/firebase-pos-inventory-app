import 'package:flutter/material.dart';

import '../dialogs/calculadora_dialog.dart';
import '../dialogs/editar_producto_dialog.dart';
import '../dialogs/nueva_nota_dialog.dart';
import '../screens/notas_page.dart';
import '../screens/ventas_page.dart';
import '../services/notas_service.dart';
import 'main_drawer.dart';
import '../widgets/balance_card.dart';
import '../widgets/logo.dart';
import '../widgets/notification_button.dart';
import '../widgets/section_title.dart';
import '../screens/perfil_page.dart';

class HomePageDemo extends StatefulWidget {
  const HomePageDemo({super.key});

  @override
  State<HomePageDemo> createState() => _HomePageDemoState();
}

class _HomePageDemoState extends State<HomePageDemo> {
  static const _green = Color(0xFF173D30);
  static const _lime = Color(0xFFB7F25C);
  static const _background = Color(0xFFF4F7F5);
  static const _text = Color(0xFF17201C);
  static const _muted = Color(0xFF748079);

  void _onProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PerfilPage()),
    );
  }

  void _openSales() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VentasPage()),
    );
  }

  void _openNotes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotasPage()),
    );
  }

  void _openPurchase() => mostrarDialogAgregarProducto(context);

  void _openNewNote() => mostrarDialogAgregarNota(context);

  void _openCalculator() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      //backgroundColor: Colors.transparent,
      builder: (_) => const CalculadoraDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      drawer: MainDrawer(
        onProfile: _onProfile,
        onSales: _openSales,
        onPurchases: _openPurchase,
        onNotes: _openNotes,
      ),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: _text,
        titleSpacing: 2,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Logo(),
            SizedBox(width: 10),
            Text(
              'Nexo',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: const [
          NotificationButton(),
          SizedBox(width: 4),
          CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFE7C9FF),
            child: Text(
              'AM',
              style: TextStyle(
                color: Color(0xFF57346E),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: RefreshIndicator(
              color: _green,
              onRefresh: () async => setState(() {}),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 28, 18, 110),
                    sliver: SliverList.list(
                      children: [
                        const Text(
                          'PANEL PRINCIPAL',
                          style: TextStyle(
                            color: Color(0xFF4A755C),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'Buenos días, Andrea',
                          style: TextStyle(
                            color: _text,
                            fontSize: 28,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Todo está en orden. Aquí tienes el resumen de tu negocio.',
                          style: TextStyle(
                            color: _muted,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 26),
                        const BalanceCard(),
                        const SizedBox(height: 32),
                        const SectionTitle(
                          title: 'Acciones rápidas',
                          subtitle: 'Todo lo que necesitas, a un toque',
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.05,
                          children: [
                            _ActionCard(
                              title: 'Nueva venta',
                              subtitle: 'Registra un ingreso',
                              icon: Icons.attach_money_rounded,
                              color: const Color(0xFF237552),
                              background: const Color(0xFFDFF6E9),
                              onTap: _openSales,
                            ),
                            _ActionCard(
                              title: 'Nueva compra',
                              subtitle: 'Agrega una compra',
                              icon: Icons.shopping_cart_outlined,
                              color: const Color(0xFF386BAA),
                              background: const Color(0xFFE3EFFC),
                              onTap: _openPurchase,
                            ),
                            _ActionCard(
                              title: 'Ver notas',
                              subtitle: 'Revisa tus pendientes',
                              icon: Icons.note_alt_outlined,
                              color: const Color(0xFF99701D),
                              background: const Color(0xFFFFF1C9),
                              onTap: _openNotes,
                            ),
                            _ActionCard(
                              title: 'Calculadora',
                              subtitle: 'Haz una operación',
                              icon: Icons.calculate_outlined,
                              color: const Color(0xFF8055A3),
                              background: const Color(0xFFF1E6F9),
                              onTap: _openCalculator,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            const Expanded(
                              child: SectionTitle(
                                title: 'Notas recientes',
                                subtitle: 'Pendientes y recordatorios',
                              ),
                            ),
                            IconButton(
                              tooltip: 'Ver todas',
                              onPressed: _openNotes,
                              style: IconButton.styleFrom(
                                foregroundColor: _green,
                                backgroundColor: const Color(0xFFE7F2EB),
                              ),
                              icon: const Icon(Icons.arrow_forward_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _NotesList(onCreate: _openNewNote),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 6,
        backgroundColor: _lime,
        foregroundColor: _green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        onPressed: _openNewNote,
        child: const Icon(Icons.add_rounded, size: 29),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE0E7E3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF2B3732),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF8A958F),
                  fontSize: 11,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotesList extends StatelessWidget {
  const _NotesList({required this.onCreate});

  final VoidCallback onCreate;

  static const _fallbackColors = [
    Color(0xFFE7F6ED),
    Color(0xFFFFF2D2),
    Color(0xFFF0E8F7),
    Color(0xFFE3EFFC),
  ];

  Color _noteColor(dynamic rawColor, int index) {
    if (rawColor is int) {
      return Color.alphaBlend(Color(rawColor).withOpacity(0.18), Colors.white);
    }
    return _fallbackColors[index % _fallbackColors.length];
  }

  Future<void> _delete(BuildContext context, String id, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        icon: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE9E5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.delete_outline_rounded,
            color: Color(0xFFB95343),
          ),
        ),
        title: const Text('¿Eliminar nota?', textAlign: TextAlign.center),
        content: Text(
          'La nota “$title” se eliminará permanentemente.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB95343),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await NotasService.eliminarNota(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: NotasService.obtenerNota(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 150,
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF173D30)),
            ),
          );
        }

        if (snapshot.hasError) {
          return const _MessageCard(
            icon: Icons.error_outline_rounded,
            title: 'No fue posible cargar las notas',
            description: 'Comprueba tu conexión e inténtalo nuevamente.',
          );
        }

        final docs = snapshot.data?.docs;
        if (docs == null || docs.isEmpty) {
          return _EmptyNotes(onCreate: onCreate);
        }

        return ListView.separated(
          itemCount: docs.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final title = data['titulo']?.toString() ?? 'Sin título';

            return _NoteCard(
              title: title,
              content: data['contenido']?.toString() ?? '',
              color: _noteColor(data['color'], index),
              onDelete: () => _delete(context, doc.id, title),
            );
          },
        );
      },
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.title,
    required this.content,
    required this.color,
    required this.onDelete,
  });

  final String title;
  final String content;
  final Color color;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 155),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0x0F1E3C30)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CircleAvatar(radius: 4, backgroundColor: Color(0xFF638170)),
                    SizedBox(width: 7),
                    Text(
                      'NOTA',
                      style: TextStyle(
                        color: Color(0xFF687970),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF17201C),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF5B6862),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: IconButton(
              tooltip: 'Eliminar nota',
              onPressed: onDelete,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.65),
                foregroundColor: const Color(0xFF93574B),
              ),
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyNotes extends StatelessWidget {
  const _EmptyNotes({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 38),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFCFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCED9D3)),
      ),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F2EB),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.note_alt_outlined,
              color: Color(0xFF3C7157),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Todavía no hay notas',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Crea una nota para mantener todo bajo control.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF77837D), fontSize: 13),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Crear mi primera nota'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF285B45),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFECE8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFB95343)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF7B625D), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

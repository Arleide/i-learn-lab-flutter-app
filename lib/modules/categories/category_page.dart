import 'package:flutter/material.dart';
import 'package:i_learn_lab_app_flutter/modules/categories/categoria.dart';
import 'package:i_learn_lab_app_flutter/modules/categories/categoria_service.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final categoriaService = CategoriaService();

  List<Categoria> categorias = [];
  bool loading = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    setState(() {
      loading = true;
      erro = null;
    });

    try {
      final lista = await categoriaService.listarTodas();

      setState(() {
        categorias = lista;
      });
    } catch (ex) {
      setState(() {
        erro = 'Erro ao carregar categorias';
        categorias = [];
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorias'),
        centerTitle: true,
        backgroundColor: const Color(0XFF0C1B2A),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (erro != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(erro!, style: TextStyle(color: Colors.red)),
            const SizedBox(height: 2),
            ElevatedButton.icon(
              onPressed: carregar,
              label: const Text('Tentar novamente'),
              icon: const Icon(Icons.refresh),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C1B2A),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (categorias.isEmpty) {
      return Center(child: Text('Nenhum Registro encontrado'));
    }

    return RefreshIndicator(
      onRefresh: carregar,
      child: ListView.builder(
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final item = categorias[index];

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.category),
                title: Text(item.nome!),
                subtitle: Text(item.id.toString()),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}

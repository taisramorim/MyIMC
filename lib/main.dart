import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

part 'main.g.dart';

@HiveType(typeId: 0)
class IMC {
  @HiveField(0)
  String nome;

  @HiveField(1)
  int idade;

  @HiveField(2)
  double altura;

  @HiveField(3)
  double peso;

  IMC(this.nome, this.idade, this.altura, this.peso);

  double calculeIMC() {
    return peso / ((altura / 100) * (altura / 100));
  }

  String getIMCClassificacao() {
    final imc = calculeIMC();
    if (imc < 18.5) {
      return 'Abaixo do peso';
    } else if (imc < 24.9) {
      return 'Peso adequado';
    } else if (imc < 29.9) {
      return 'Sobrepeso';
    } else {
      return 'Obeso';
    }
  }

  String getRecommendations() {
    final imc = calculeIMC();
    if (imc < 18.5) {
      return '- Consume a balanced diet with extra calories\n- Include more protein-rich foods\n- Engage in strength training exercises';
    } else if (imc < 24.9) {
      return '- Maintain a balanced diet\n- Regularly engage in both cardio and strength training exercises';
    } else if (imc < 29.9) {
      return '- Adopt a calorie-controlled diet\n- Increase physical activity, focusing on cardio exercises';
    } else {
      return '- Seek professional medical advice\n- Develop a comprehensive peso management plan';
    }
  }
}

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(IMCAdapter());
  await Hive.openBox<IMC>('imcBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      title: 'IMC Calculadora',
      home: const IMCCalculadora(),
    );
  }
}

class IMCCalculadora extends StatefulWidget {
  const IMCCalculadora({super.key});

  @override
  State<IMCCalculadora> createState() => _IMCCalculadoraState();
}

class _IMCCalculadoraState extends State<IMCCalculadora> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IMC Calculadora'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: idadeController,
                decoration: const InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: alturaController,
                decoration: const InputDecoration(labelText: 'Altura (cm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: pesoController,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (nomeController.text.isNotEmpty &&
                      idadeController.text.isNotEmpty &&
                      alturaController.text.isNotEmpty &&
                      pesoController.text.isNotEmpty) {
                    final nome = nomeController.text;
                    final idade = int.parse(idadeController.text);
                    final altura = double.parse(alturaController.text);
                    final peso = double.parse(pesoController.text);

                    final imc = IMC(nome, idade, altura, peso);

                    final box = Hive.box<IMC>('imcBox');
                    box.add(imc);

                    // Clear the input fields
                    nomeController.clear();
                    idadeController.clear();
                    alturaController.clear();
                    pesoController.clear();
                  }
                },
                child: const Text('Calcule o IMC'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<IMC>('imcBox').listenable(),
                  builder: (context, box, _) {
                    return ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (BuildContext context, int index) {
                        final imc = box.getAt(index) as IMC;
                        final imcValue = imc.calculeIMC();
                        final imcClassificacao = imc.getIMCClassificacao();

                        return Card(
                          elevation: 3,
                          child: ListTile(
                            title: Text(
                              '${imc.nome}, ${imc.idade} anos',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('IMC: ${imcValue.toStringAsFixed(2)}'),
                                Text('Classificação: $imcClassificacao'),
                                Text(
                                    'Data: ${DateFormat('dd/MM/yy').format(DateTime.now())}'),
                                const SizedBox(height: 8),
                                Text(
                                  imc.getRecommendations(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                box.deleteAt(index);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

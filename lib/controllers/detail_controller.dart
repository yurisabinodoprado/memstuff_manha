import 'package:memstuff_manha/models/stuff_model.dart';
import 'package:memstuff_manha/repositories/stuff_repository.dart';

class DetailController {
  final StuffRepository _repository;

  DetailController(this._repository);

  int id;
  String photo = '';
  String description = '';
  String name = '';
  String date = '';
  String telefone = '';

  setId(int value) => id = value;
  setPhoto(String value) => photo = value;
  setDescription(String value) => description = value;
  setName(String value) => name = value;
  setDate(String value) => date = value;
  setTelefone(String value) => telefone = value;
  Future save() async {
    final stuff = StuffModel(
      id: id,
      photoPath: photo,
      description: description,
      contactName: name,
      date: date,
      telefone: telefone,
    );

    if (id == null) {
      await _repository.create(stuff);
    } else {
      await _repository.update(stuff);
    }
    if (name == null) {}
    if (description == null) {}
  }
}

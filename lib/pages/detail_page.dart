import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:memstuff_manha/controllers/detail_controller.dart';
import 'package:memstuff_manha/core/app_const.dart';
import 'package:memstuff_manha/helpers/snackbar_helper.dart';
import 'package:memstuff_manha/helpers/validator_helper.dart';

import 'package:memstuff_manha/models/stuff_model.dart';
import 'package:memstuff_manha/repositories/stuff_repository_impl.dart';
import 'package:memstuff_manha/widgets/date_input_field.dart';
import 'package:memstuff_manha/widgets/loading_dialog.dart';
import 'package:memstuff_manha/widgets/photo_input_area.dart';
import 'package:memstuff_manha/widgets/primary_button.dart';
import 'package:memstuff_manha/widgets/text_input_field.dart';

class DetailPage extends StatefulWidget {
  final StuffModel stuff;

  const DetailPage({
    Key key,
    this.stuff,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = DetailController(StuffRepositoryImpl());

  @override
  void initState() {
    _controller.setId(widget.stuff?.id);
    _controller.setPhoto(widget.stuff?.photoPath);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stuff == null ? kTitleNewLoad : kTitleDetails),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: _buildForm(),
      ),
    );
  }

  _buildForm() {
    var maskFormatter = new MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
    );
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PhotoInputArea(
            initialValue: widget.stuff?.photoPath ?? '',
            onChanged: _controller.setPhoto,
          ),
          TextInputField(
            label: kLabelDescription,
            icon: Icons.description_outlined,
            initialValue: widget.stuff?.description ?? '',
            onSaved: _controller.setDescription,
          ),
          TextFormField(
            initialValue: widget.stuff?.telefone ?? '',
            onSaved: _controller.setTelefone,
            decoration: InputDecoration(
              labelText: kLabelTelefone,
              prefixIcon: Icon(Icons.phone),
            ),
            validator: ValidatorHelper.isValidText,
            keyboardType: TextInputType.phone,
            inputFormatters: [maskFormatter],
          ),
          TextInputField(
            label: kLabelName,
            icon: Icons.person_outline,
            initialValue: widget.stuff?.contactName ?? '',
            onSaved: _controller.setName,
          ),
          DateInputField(
            label: kLabelLoadDate,
            initialValue: widget.stuff?.date ?? '',
            onSaved: _controller.setDate,
          ),
          PrimaryButton(
            label: kButtonSave,
            onPressed: _onSave,
          ),
        ],
      ),
    );
  }

  Future _onSave() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      LoadingDialog.show(
        context,
        message: widget.stuff == null ? 'Salvando...' : 'Atualizando...',
      );
      await _controller.save();
      LoadingDialog.hide();
      Navigator.of(context).pop();
      _onSuccessMessage();
    }
  }

  _onSuccessMessage() {
    if (widget.stuff == null) {
      SnackbarHelper.showCreateMessage(
        context: context,
        message: '${_controller.description} criado com sucesso!',
      );
    } else {
      SnackbarHelper.showUpdateMessage(
        context: context,
        message: '${_controller.description} atualizado com sucesso!',
      );
    }
  }
}

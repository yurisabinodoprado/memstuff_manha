import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:memstuff_manha/models/stuff_model.dart';

import '../helpers/date_helper.dart';

class StuffCard extends StatelessWidget {
  final StuffModel stuff;
  final Function onUpdate;
  final Function onDelete;
  final Function onTel;

  const StuffCard({
    Key key,
    this.stuff,
    this.onUpdate,
    this.onDelete,
    this.onTel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: _buildCard(),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Excluir',
          color: Theme.of(context).accentColor,
          icon: Icons.delete,
          onTap: onDelete,
        ),
        IconSlideAction(
          caption: 'Ligar',
          color: Theme.of(context).accentColor,
          icon: Icons.phone,
          onTap: onTel,
        ),
      ],
    );
  }

  _buildCard() {
    return InkWell(
      onTap: onUpdate,
      child: Container(
        child: ListTile(
          title: Text(stuff.description ?? ''),
          subtitle: Text(stuff.contactName ?? ''),
          trailing: Container(
            padding: const EdgeInsets.only(top: 8),
            height: double.infinity,
            child: Text(DateHelper.relative(stuff.date)),
          ),
          leading: CircleAvatar(
            backgroundImage:
                stuff.hasPhoto ? FileImage(File(stuff.photoPath)) : null,
            child: stuff.hasPhoto ? null : Text(stuff.description[0]),
          ),
        ),
      ),
    );
  }
}

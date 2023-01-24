import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/constants/api_constants.dart';
import 'package:flutter_webapi_first_course/constants/app_constants.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/commom/confirmation_dialog.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';

class JournalCard extends StatelessWidget {
  final Journal? journal;
  final DateTime showedDate;
  final Function refreshFunction;
  final int userId;
  final String token;
  const JournalCard(
      {Key? key,
      this.journal,
      required this.showedDate,
      required this.refreshFunction,
      required this.userId,
      required this.token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (journal != null) {
      return InkWell(
        onTap: () {
          callAddJournalScreen(
            context,
            journal: journal,
          );
        },
        child: Container(
          height: 115,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black87,
            ),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      border: Border(
                          right: BorderSide(color: Colors.black87),
                          bottom: BorderSide(color: Colors.black87)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      journal!.createdAt.day.toString(),
                      style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 38,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.black87),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(WeekDay(journal!.createdAt).short),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    journal!.content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    removeJournal(context);
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          callAddJournalScreen(context);
        },
        child: Container(
          height: 115,
          alignment: Alignment.center,
          child: Text(
            "${WeekDay(showedDate).short} - ${showedDate.day}",
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void callAddJournalScreen(BuildContext context, {Journal? journal}) {
    Map<String, dynamic> map = {};
    map[argumentIsEditing] = journal != null;
    map[argumentJournal] =
        journal ??= Journal.empty(showedDate: showedDate, userId: userId);
    Navigator.pushNamed(context, routeAddJournalScreen, arguments: map)
        .then((value) {
      refreshFunction();
      if (value != null) {
        if (value == statusCodeCreated) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Diário criado!")));
        } else if (value == statusCodeOk) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Diário alterado!")));
        }
      }
    });
  }

  removeJournal(BuildContext context) {
    showConfirmationDialog(
      context,
      content:
          "Deseja realmente remover o diário do dia ${WeekDay(journal!.createdAt)}?",
      affirmativeOption: "Remover",
    ).then((value) {
      if (value != null && value) {
        final JournalService service = JournalService();
        service.delete(journal!.id, token).then((value) {
          refreshFunction();
          if (value == statusCodeOk) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Diário removido!")));
          }
        });
      }
    });
  }
}

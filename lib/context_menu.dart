import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:docare/doc_web.dart'; 

class CustomContextMenuArea extends StatelessWidget {
  final Widget child;

  CustomContextMenuArea({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapUp: (details) {
        // Add context menu event listener
        void contextMenuListener(html.Event event) {
          event.preventDefault();
          // Remove the event listener after it's triggered
          html.window.removeEventListener('contextmenu', contextMenuListener);
        }

        html.window.addEventListener('contextmenu', contextMenuListener);

        // Show the custom context menu
        final position = details.globalPosition;
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            position.dx,
            position.dy,
            position.dx,
            position.dy,
          ),
          items: [
            const PopupMenuItem(
              value: 'new_document',
              child: Text('Nouveau Document'),
            ),
            const PopupMenuItem(
              value: 'new_folder',
              child: Text('Nouveau dossier'),
            ),
          ],
        ).then((value) {
          if (value == 'new_folder') {
            //newFolder();
          } else if (value == 'new_document') {
            newDocument(context);
          }
        });
      },
      child: child,
    );
  }
}

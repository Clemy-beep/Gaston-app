import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../services/model-services/notification_model_service.dart';

/*
* SI VOUS VOULEZ CREER UNE NOTIFICATION vous copiez coller la methode et mettez le message que vous voulez et ensuite vous importer le fichier 
* sinon demandez moi
*/

class NotificationTimerWidget {
  final NotificationModelService _notificationService =
      NotificationModelService();

  Future<void> endTimer() async {
    await _notificationService.demoNotification('Chrono terminé', 'revenez !');
  }

  Future<void> specialNotification() async {
    await _notificationService.demoNotification('Je suis special', 'special');
  }
}

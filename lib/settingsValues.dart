import 'package:flutter/material.dart';

// final ValueNotifier<ThemeMode> theme = ValueNotifier(ThemeMode.light);
final ValueNotifier<String> font = ValueNotifier('Roboto');
final ValueNotifier<String> currency = ValueNotifier('CAD');
final ValueNotifier<String> language = ValueNotifier('English');

double convertPrice(double price, String currency){
  double result = price;
  if(currency == 'USD'){
    result = price * 0.74;
  }
  return result;
}

Map<String, Map<String, String>> translations = {
  'English' : {
    'categories': 'Categories',
    'subscriptions': 'Subscriptions',
    'addCategory': 'Add Category',
    'settings': 'Settings',
    'darkMode': 'Dark Mode',
    'font': 'Font',
    'currency': 'Currency',
    'languages': 'Languages',
    'logOut': 'Log Out',
    'totalMonthly': 'Total Monthly',
    'noCategories': 'No Categories',
    'noSubscriptions': 'No subscriptions found.',
    'editSubscriptions': 'Edit subscriptions',
    'addSubscription': 'Add Subscription',
    'addSubscription2': 'Add Subscription to get Started',
    'saveChanges': 'Save Changes',
    'name': 'Name',
    'price': 'Price',
    'category': 'Category',
    'interval': 'Interval',
    'icon': 'Icon',
    'empty': 'Do not leave anything empty',
    's': 'Category Successfully Added',
    'chart': 'Chart Unavailable',
    'ss': 'Subscription Successfully Added',
    'subscriptionUpdated': 'Subscription Successfully Updated',
  },
  'Français' : {
    'categories': 'Catégories',
    'subscriptions': 'Abonnements',
    'addCategory': 'Ajouter une catégorie',
    'settings': 'Paramètres',
    'darkMode': 'Mode sombre',
    'font': 'Fonte',
    'currency': 'Devise',
    'languages': 'Langues',
    'logOut': 'Se déconnecter',
    'totalMonthly': 'Total mensuel',
    'noCategories': 'Aucune catégorie trouvé',
    'noSubscriptions': 'Aucun abonnement trouvé.',
    'editSubscriptions': 'Modifier les abonnements',
    'addSubscription': 'Ajouter un abonnement',
    'addSubscription2': 'Ajoutez un abonnement pour commencer.',
    'saveChanges': 'Sauvegarder',
    'name': 'Nom',
    'price': 'Prix',
    'category': 'Catégorie',
    'interval': 'Intervalle',
    'icon': 'Icône',
    'empty': 'Ne laissez rien vide.',
    's': 'Catégorie ajoutée avec succès',
    'chart': 'Graphique indisponible',
    'ss': 'Abonnement ajouté avec succès',
    'subscriptionUpdated': 'Abonnement mis à jour avec succès',
  },
  'Español' : {
    'categories': 'Categorías',
    'subscriptions': 'Suscripciones',
    'addCategory': 'Añadir una categoría',
    'settings': 'Configuración',
    'darkMode': 'Mode sombre',
    'font': 'Fuente',
    'currency': 'Moneda',
    'languages': 'Idiomas',
    'logOut': 'Cerrar sesión',
    'totalMonthly': 'Total Mensual',
    'noCategories': 'No se encontraron categorías',
    'noSubscriptions': 'No se encontraron suscripciones',
    'editSubscriptions': 'Editar suscripciones',
    'addSubscription': 'Añadir una suscripción',
    'addSubscription2': 'Añadir una suscripción para empezar.',
    'saveChanges': 'Guardar',
    'name': 'Nombre',
    'price': 'Precio',
    'category': 'Categoría',
    'interval': 'Intervalo',
    'icon': 'Icono',
    'empty': 'No deje ningún campo vacío.',
    's': 'Categoría añadida correctamente',
    'chart': 'Gráfico no disponible',
    'ss': 'Suscripción añadida correctamente',
    'subscriptionUpdated': 'Suscripción actualizada correctamente',
  }
};

String translate(String key){
  return translations[language.value]?[key] ?? key;
}
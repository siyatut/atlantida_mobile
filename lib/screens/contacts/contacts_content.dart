import '../../utils/text_utils.dart';

class ContactsContent {
  static const phones = <ContactPhone>[
    ContactPhone(
      title: 'Магазин',
      phoneUi: '+7 (962) 504-60-96',
      tel: '+79625046096',
    ),
    ContactPhone(
      title: 'Людмила',
      phoneUi: '+7 (903) 059-59-92',
      tel: '+79030595992',
    ),
    ContactPhone(
      title: 'Александр',
      phoneUi: '+7 (906) 351-17-06',
      tel: '+79063511706',
    ),
  ];

  static const telegramUrl = 'https://t.me/gagin645';

  static const addressTitle = 'Нижний Новгород, ул. Коминтерна, 117';
  static const addressSubtitle =
      'Универмаг «Сормовские Зори», 1 этаж, левое крыло — за аптекой.';
  static const addressFull =
      'Нижний Новгород, ул. Коминтерна, 117, Универмаг «Сормовские Зори», 1 этаж, левое крыло';

  static String addressTitleUi() => splitTitleInTwo(fixPrepositions(addressTitle));
  static String addressSubtitleUi() => fixPrepositions(addressSubtitle);
  static String addressFullUi() => fixPrepositions(addressFull);

  static const yandexRouteUrl =
      'https://yandex.ru/maps/?pt=43.868429,56.350553&z=17&l=map';
  static const googleRouteUrl =
      'https://www.google.com/maps/search/?api=1&query=56.350282512393726, 43.86842794102657';
}

class ContactPhone {
  final String title;
  final String phoneUi;
  final String tel;
  const ContactPhone({
    required this.title,
    required this.phoneUi,
    required this.tel,
  });
}
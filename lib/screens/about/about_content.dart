import 'package:flutter/material.dart';
import '../../utils/text_utils.dart';

class AboutContent {
  static String heroTitle() => fixPrepositions(
        'Не откладывайте заботу \nо вашем питомце на потом!',
      );

  static String heroSubtitle() => fixPrepositions(
        'Посетите зоомагазин «Атлантида» в Нижнем Новгороде — у нас есть всё для здоровья и комфорта вашего любимца. '
        'Качественные товары, честные цены и помощь консультантов.',
      );

  static const intro = AboutSection(
    'О магазине',
    [
      'Зоомагазин «Атлантида» — это профессиональная аквариумистика и широкий ассортимент товаров для домашних питомцев.',
      'Мы работаем с 2015 года и за это время помогли тысячам владельцев создать идеальные условия для своих любимцев.', 
      'Наша команда профессионалов всегда готова проконсультировать вас по любым вопросам.',
    ],
  );

  static const benefits = <AboutBenefitData>[
    AboutBenefitData(
      icon: Icons.verified_outlined,
      title: 'Гарантия качества',
      subtitle: 'Все товары сертифицированы и проходят строгий контроль',
    ),
    AboutBenefitData(
      icon: Icons.local_shipping_outlined,
      title: 'Бесплатная доставка',
      subtitle: 'При заказе аквариума от 10\u00A0000\u00A0₽ доставим до дома бесплатно',
    ),
    AboutBenefitData(
      icon: Icons.people_outline,
      title: 'Консультации экспертов',
      subtitle: 'Бесплатные консультации по выбору и уходу за питомцами',
    ),
    AboutBenefitData(
      icon: Icons.shopping_bag_outlined,
      title: 'Широкий ассортимент',
      subtitle: 'Аквариумы, оборудование, живые растения, рыбки и многое другое',
    ),
  ];

  static const features = <AboutFeatureData>[
    AboutFeatureData(icon: Icons.water_outlined, text: 'Аксессуары и аквариумы'),
    AboutFeatureData(icon: Icons.grass_outlined, text: 'В продаже живые рыбки и растения'),
    AboutFeatureData(icon: Icons.shopping_cart_outlined, text: 'Большой ассортимент товаров'),
    AboutFeatureData(icon: Icons.support_agent_outlined, text: 'Профессиональные консультанты'),
    AboutFeatureData(icon: Icons.favorite_outline, text: 'Клиентоориентированный подход'),
    AboutFeatureData(icon: Icons.attach_money, text: 'Доступные цены'),
  ];

  static const accordion = <AboutAccordionItemData>[
    AboutAccordionItemData(
      title: 'Разнообразие товаров для ваших любимцев',
      text:
          'Товары для всех видов домашних животных, включая собак, кошек, грызунов, птиц, рептилий и рыбок. '
          'У нас есть всё, что нужно вашему питомцу для комфортной и здоровой жизни.',
    ),
    AboutAccordionItemData(
      title: 'Аквариумы и оборудование',
      text:
          'Если любите аквариумных рыбок, в нашем магазине вы найдёте всё для создания прекрасного подводного мира: '
          'аквариумы разных форм и размеров, фильтры, нагреватели, освещение и украшения.',
    ),
    AboutAccordionItemData(
      title: 'Корма для животных',
      text:
          'Правильное питание — ключ к здоровью питомца. '
          'В «Атлантиде» большой выбор кормов для аквариумных рыбок: на каждый день, для роста и окраса. '
          'Также у нас есть корма для собак и кошек разных пород и возрастов, '
          'а ещё для грызунов, птиц и рептилий.',
    ),
    AboutAccordionItemData(
      title: 'Сопутствующие товары',
      text:
          'Наполнители, миски, поводки, игрушки и многое другое. '
          'Мы поможем подобрать всё необходимое, чтобы жизнь вашего питомца была удобной и интересной для вас обоих.',
    ),
  ];
}

class AboutSection {
  final String title;
  final List<String> paragraphs;
  const AboutSection(this.title, this.paragraphs);
}

class AboutFeatureData {
  final IconData icon;
  final String text;
  const AboutFeatureData({required this.icon, required this.text});
}

class AboutAccordionItemData {
  final String title;
  final String text;
  const AboutAccordionItemData({required this.title, required this.text});
}

class AboutBenefitData {
  final IconData icon;
  final String title;
  final String subtitle;
  const AboutBenefitData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
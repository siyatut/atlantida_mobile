import 'package:flutter/material.dart';

class HomeContent {
  static const heroLines = <String>[
    'ЗООТОВАРЫ',
    'АКВАРИУМЫ',
    'ОБОРУДОВАНИЕ',
    'КОРМА ДЛЯ ВАШИХ',
    'ДОМАШНИХ ЛЮБИМЦЕВ',
    'И ДРУГИЕ ТОВАРЫ',
  ];

  static const aboutTitle = 'Зоомагазин в Нижнем Новгороде';

  static const aboutText =
      '11 лет опыта. 3 000+ наименований.\nЛюбовь к питомцам начинается здесь!';

  static const qualityTitle = 'Качество и поставщики';

  static const qualityText =
      'Все товары, представленные в магазине «Атлантида», соответствуют стандартам.\n '
      '\nМы выбираем для вас проверенных поставщиков и качественную продукцию.';

  static const advantagesTitle = 'Преимущества';

  static const advantages = <HomeAdvantage>[
    HomeAdvantage(
      icon: Icons.local_shipping_outlined,
      title: 'Доставка на дом',
      text: 'При покупке аквариума от 10\u00A0000\u00A0₽ доставим на дом.',
    ),
    HomeAdvantage(
      icon: Icons.attach_money,
      title: 'Держим низкие цены',
      text: 'Более 11 лет мы предлагаем товары по доступным ценам.',
    ),
    HomeAdvantage(
      icon: Icons.inventory_2_outlined,
      title: 'Большой ассортимент',
      text: 'Аквариумы, фильтры, корма, игрушки и многое другое.',
    ),
  ];

  static const whyTitle = 'Почему выбирают «Атлантиду»';

  static const whyFeatures = <HomeFeature>[
    HomeFeature(icon: Icons.water_outlined, text: 'Аксессуары и аквариумы'),
    HomeFeature(icon: Icons.shopping_cart_outlined, text: 'Большой ассортимент товаров'),
    HomeFeature(icon: Icons.support_agent_outlined, text: 'Профессиональные консультанты'),
    HomeFeature(icon: Icons.emoji_people_outlined, text: 'Клиентоориентированный подход'),
    HomeFeature(icon: Icons.grass_outlined, text: 'Живые рыбки и растения'),
    HomeFeature(icon: Icons.attach_money, text: 'Доступные цены'),
  ];
}

class HomeAdvantage {
  final IconData icon;
  final String title;
  final String text;
  const HomeAdvantage({
    required this.icon,
    required this.title,
    required this.text,
  });
}

class HomeFeature {
  final IconData icon;
  final String text;
  const HomeFeature({required this.icon, required this.text});
}

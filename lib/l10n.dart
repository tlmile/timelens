
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timelens/data_providers/l10n/fluent_l10n_provider.dart';

import 'package:timelens/data_providers/l10n/l10n_provider.dart';

class L10N {
  final Locale locale; //当前语言/地区
  final L10NProvider tr; //翻译提供者（真正返回方案的对象）
  final bool rtl; //是否右到左布局
  const L10N._internal(this.locale,this.tr,this.rtl);
  static Future<L10N> load(Locale locale) async {
    //Intl 为Dart国际化库设置全局语言环境 == 怎么格式化数字及时间
    //Fluent为提供人类可读的多语言文本格式，语言资源系统(第三方) == 怎么组织翻译文本
    Intl.defaultLocale = locale.languageCode;
    L10NProvider tr = await FluentL10NProvider.load(locale);
    return L10N._internal(locale, tr, locale.languageCode == "en");
  }

  //of：flutter经典命名约定，用于从BuildContext获取某个全局对象
  static L10N of(BuildContext context){
    //在当前widget树(context)查找并返回一个类型为L10N的本地化对象实例
    final res = Localizations.of<L10N>(context,L10N);
    assert(res != null,'L10N not found in context, Did you add L10N.delegate?');
    return res!; //dart 2.12后引入空安全特性【非空断言操作符】，表示可能返回空值
  }

  static const LocalizationsDelegate<L10N> delegate = _L10NDelegate();
}

//_L10NDelegate 表示是一个私有类
class _L10NDelegate extends LocalizationsDelegate<L10N> {
  //const 构造函数表示可以作为常量实例(节省内容)
  const _L10NDelegate();
  @override
  bool isSupported(Locale locale) => [
    'en',
    'zh',
    'nb',
  ].contains(locale.languageCode);

  @override
  Future<L10N> load(Locale locale) => L10N.load(locale);

  @override
  bool shouldReload(_L10NDelegate old) => false;
}
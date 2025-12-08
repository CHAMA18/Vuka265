import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en', 'zh', 'es', 'hi', 'fr', 'ar', 'ru', 'ja'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? (kTranslationsMap[key] ?? {})['en'] ?? key;

  String getVariableText({
    String? enText = '',
    String? zhText = '',
    String? esText = '',
    String? hiText = '',
    String? frText = '',
    String? arText = '',
    String? ruText = '',
    String? jaText = '',
  }) =>
      [enText, zhText, esText, hiText, frText, arText, ruText, jaText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final Map<String, Map<String, String>> kTranslationsMap = {
  // Navigation
  'home': {'en': 'Home', 'zh': '首页', 'es': 'Inicio', 'hi': 'होम', 'fr': 'Accueil', 'ar': 'الرئيسية', 'ru': 'Главная', 'ja': 'ホーム'},
  'matches': {'en': 'Matches', 'zh': '匹配', 'es': 'Coincidencias', 'hi': 'मैच', 'fr': 'Matchs', 'ar': 'التطابقات', 'ru': 'Совпадения', 'ja': 'マッチ'},
  'chats': {'en': 'Chats', 'zh': '聊天', 'es': 'Chats', 'hi': 'चैट', 'fr': 'Discussions', 'ar': 'الدردشات', 'ru': 'Чаты', 'ja': 'チャット'},
  'profile': {'en': 'Profile', 'zh': '个人资料', 'es': 'Perfil', 'hi': 'प्रोफ़ाइल', 'fr': 'Profil', 'ar': 'الملف الشخصي', 'ru': 'Профиль', 'ja': 'プロフィール'},
  
  // Settings
  'settings': {'en': 'Settings', 'zh': '设置', 'es': 'Configuración', 'hi': 'सेटिंग्स', 'fr': 'Paramètres', 'ar': 'الإعدادات', 'ru': 'Настройки', 'ja': '設定'},
  'app_appearance': {'en': 'App Appearance', 'zh': '应用外观', 'es': 'Apariencia', 'hi': 'ऐप प्रकटन', 'fr': 'Apparence', 'ar': 'مظهر التطبيق', 'ru': 'Внешний вид', 'ja': 'アプリの外観'},
  'app_language': {'en': 'App Language', 'zh': '应用语言', 'es': 'Idioma', 'hi': 'ऐप भाषा', 'fr': 'Langue', 'ar': 'لغة التطبيق', 'ru': 'Язык приложения', 'ja': 'アプリの言語'},
  'display_mode': {'en': 'Display Mode', 'zh': '显示模式', 'es': 'Modo de Pantalla', 'hi': 'डिस्प्ले मोड', 'fr': 'Mode d\'affichage', 'ar': 'وضع العرض', 'ru': 'Режим отображения', 'ja': '表示モード'},
  'notifications': {'en': 'Notifications', 'zh': '通知', 'es': 'Notificaciones', 'hi': 'सूचनाएं', 'fr': 'Notifications', 'ar': 'الإشعارات', 'ru': 'Уведомления', 'ja': '通知'},
  'privacy': {'en': 'Privacy', 'zh': '隐私', 'es': 'Privacidad', 'hi': 'गोपनीयता', 'fr': 'Confidentialité', 'ar': 'الخصوصية', 'ru': 'Конфиденциальность', 'ja': 'プライバシー'},
  'security': {'en': 'Security', 'zh': '安全', 'es': 'Seguridad', 'hi': 'सुरक्षा', 'fr': 'Sécurité', 'ar': 'الأمان', 'ru': 'Безопасность', 'ja': 'セキュリティ'},
  'help_support': {'en': 'Help & Support', 'zh': '帮助与支持', 'es': 'Ayuda y Soporte', 'hi': 'सहायता और समर्थन', 'fr': 'Aide et Support', 'ar': 'المساعدة والدعم', 'ru': 'Помощь и поддержка', 'ja': 'ヘルプとサポート'},
  'subscription': {'en': 'Subscription', 'zh': '订阅', 'es': 'Suscripción', 'hi': 'सदस्यता', 'fr': 'Abonnement', 'ar': 'الاشتراك', 'ru': 'Подписка', 'ja': 'サブスクリプション'},
  'data_usage': {'en': 'Data Usage', 'zh': '数据使用', 'es': 'Uso de Datos', 'hi': 'डेटा उपयोग', 'fr': 'Utilisation des données', 'ar': 'استخدام البيانات', 'ru': 'Использование данных', 'ja': 'データ使用量'},
  'account_security': {'en': 'Account Security', 'zh': '账户安全', 'es': 'Seguridad de la Cuenta', 'hi': 'खाता सुरक्षा', 'fr': 'Sécurité du compte', 'ar': 'أمان الحساب', 'ru': 'Безопасность аккаунта', 'ja': 'アカウントセキュリティ'},
  'logout': {'en': 'Logout', 'zh': '登出', 'es': 'Cerrar Sesión', 'hi': 'लॉगआउट', 'fr': 'Déconnexion', 'ar': 'تسجيل الخروج', 'ru': 'Выйти', 'ja': 'ログアウト'},
  'delete_account': {'en': 'Delete Account', 'zh': '删除账户', 'es': 'Eliminar Cuenta', 'hi': 'खाता हटाएं', 'fr': 'Supprimer le compte', 'ar': 'حذف الحساب', 'ru': 'Удалить аккаунт', 'ja': 'アカウントを削除'},
  
  // Actions
  'submit': {'en': 'Submit', 'zh': '提交', 'es': 'Enviar', 'hi': 'जमा करें', 'fr': 'Soumettre', 'ar': 'إرسال', 'ru': 'Отправить', 'ja': '送信'},
  'cancel': {'en': 'Cancel', 'zh': '取消', 'es': 'Cancelar', 'hi': 'रद्द करें', 'fr': 'Annuler', 'ar': 'إلغاء', 'ru': 'Отмена', 'ja': 'キャンセル'},
  'save': {'en': 'Save', 'zh': '保存', 'es': 'Guardar', 'hi': 'सहेजें', 'fr': 'Enregistrer', 'ar': 'حفظ', 'ru': 'Сохранить', 'ja': '保存'},
  'edit': {'en': 'Edit', 'zh': '编辑', 'es': 'Editar', 'hi': 'संपादित करें', 'fr': 'Modifier', 'ar': 'تعديل', 'ru': 'Редактировать', 'ja': '編集'},
  'delete': {'en': 'Delete', 'zh': '删除', 'es': 'Eliminar', 'hi': 'हटाएं', 'fr': 'Supprimer', 'ar': 'حذف', 'ru': 'Удалить', 'ja': '削除'},
  'search': {'en': 'Search', 'zh': '搜索', 'es': 'Buscar', 'hi': 'खोजें', 'fr': 'Rechercher', 'ar': 'بحث', 'ru': 'Поиск', 'ja': '検索'},
  'send': {'en': 'Send', 'zh': '发送', 'es': 'Enviar', 'hi': 'भेजें', 'fr': 'Envoyer', 'ar': 'إرسال', 'ru': 'Отправить', 'ja': '送信'},
  'done': {'en': 'Done', 'zh': '完成', 'es': 'Hecho', 'hi': 'पूर्ण', 'fr': 'Terminé', 'ar': 'تم', 'ru': 'Готово', 'ja': '完了'},
  'ok': {'en': 'OK', 'zh': '确定', 'es': 'Aceptar', 'hi': 'ठीक है', 'fr': 'OK', 'ar': 'موافق', 'ru': 'ОК', 'ja': 'OK'},
  
  // Messages
  'message': {'en': 'Message', 'zh': '消息', 'es': 'Mensaje', 'hi': 'संदेश', 'fr': 'Message', 'ar': 'رسالة', 'ru': 'Сообщение', 'ja': 'メッセージ'},
  'type_message': {'en': 'Type a message...', 'zh': '输入消息...', 'es': 'Escribe un mensaje...', 'hi': 'संदेश लिखें...', 'fr': 'Tapez un message...', 'ar': 'اكتب رسالة...', 'ru': 'Введите сообщение...', 'ja': 'メッセージを入力...'},
  'new_matches': {'en': 'New Matches', 'zh': '新匹配', 'es': 'Nuevas Coincidencias', 'hi': 'नए मैच', 'fr': 'Nouveaux Matchs', 'ar': 'تطابقات جديدة', 'ru': 'Новые совпадения', 'ja': '新しいマッチ'},
  'no_messages': {'en': 'No messages yet', 'zh': '暂无消息', 'es': 'Sin mensajes aún', 'hi': 'अभी कोई संदेश नहीं', 'fr': 'Pas de messages', 'ar': 'لا توجد رسائل بعد', 'ru': 'Пока нет сообщений', 'ja': 'まだメッセージはありません'},
  
  // Profile
  'edit_profile': {'en': 'Edit Profile', 'zh': '编辑资料', 'es': 'Editar Perfil', 'hi': 'प्रोफ़ाइल संपादित करें', 'fr': 'Modifier le profil', 'ar': 'تعديل الملف الشخصي', 'ru': 'Редактировать профиль', 'ja': 'プロフィールを編集'},
  'bio': {'en': 'Bio', 'zh': '简介', 'es': 'Biografía', 'hi': 'बायो', 'fr': 'Bio', 'ar': 'نبذة', 'ru': 'Биография', 'ja': '自己紹介'},
  'photos': {'en': 'Photos', 'zh': '照片', 'es': 'Fotos', 'hi': 'फ़ोटो', 'fr': 'Photos', 'ar': 'الصور', 'ru': 'Фотографии', 'ja': '写真'},
  'interests': {'en': 'Interests', 'zh': '兴趣', 'es': 'Intereses', 'hi': 'रुचियां', 'fr': 'Intérêts', 'ar': 'الاهتمامات', 'ru': 'Интересы', 'ja': '興味'},
  'location': {'en': 'Location', 'zh': '位置', 'es': 'Ubicación', 'hi': 'स्थान', 'fr': 'Emplacement', 'ar': 'الموقع', 'ru': 'Местоположение', 'ja': '場所'},
  'age': {'en': 'Age', 'zh': '年龄', 'es': 'Edad', 'hi': 'आयु', 'fr': 'Âge', 'ar': 'العمر', 'ru': 'Возраст', 'ja': '年齢'},
  
  // Filters
  'filters': {'en': 'Filters', 'zh': '筛选', 'es': 'Filtros', 'hi': 'फ़िल्टर', 'fr': 'Filtres', 'ar': 'الفلاتر', 'ru': 'Фильтры', 'ja': 'フィルター'},
  'distance': {'en': 'Distance', 'zh': '距离', 'es': 'Distancia', 'hi': 'दूरी', 'fr': 'Distance', 'ar': 'المسافة', 'ru': 'Расстояние', 'ja': '距離'},
  'age_range': {'en': 'Age Range', 'zh': '年龄范围', 'es': 'Rango de Edad', 'hi': 'आयु सीमा', 'fr': 'Tranche d\'âge', 'ar': 'نطاق العمر', 'ru': 'Возрастной диапазон', 'ja': '年齢範囲'},
  'gender': {'en': 'Gender', 'zh': '性别', 'es': 'Género', 'hi': 'लिंग', 'fr': 'Genre', 'ar': 'الجنس', 'ru': 'Пол', 'ja': '性別'},
  'apply_filters': {'en': 'Apply Filters', 'zh': '应用筛选', 'es': 'Aplicar Filtros', 'hi': 'फ़िल्टर लागू करें', 'fr': 'Appliquer les filtres', 'ar': 'تطبيق الفلاتر', 'ru': 'Применить фильтры', 'ja': 'フィルターを適用'},
  'reset_filters': {'en': 'Reset Filters', 'zh': '重置筛选', 'es': 'Restablecer Filtros', 'hi': 'फ़िल्टर रीसेट करें', 'fr': 'Réinitialiser', 'ar': 'إعادة تعيين', 'ru': 'Сбросить фильтры', 'ja': 'フィルターをリセット'},
  
  // Auth
  'sign_in': {'en': 'Sign In', 'zh': '登录', 'es': 'Iniciar Sesión', 'hi': 'साइन इन', 'fr': 'Se connecter', 'ar': 'تسجيل الدخول', 'ru': 'Войти', 'ja': 'サインイン'},
  'sign_up': {'en': 'Sign Up', 'zh': '注册', 'es': 'Registrarse', 'hi': 'साइन अप', 'fr': 'S\'inscrire', 'ar': 'إنشاء حساب', 'ru': 'Регистрация', 'ja': 'サインアップ'},
  'email': {'en': 'Email', 'zh': '邮箱', 'es': 'Correo electrónico', 'hi': 'ईमेल', 'fr': 'E-mail', 'ar': 'البريد الإلكتروني', 'ru': 'Эл. почта', 'ja': 'メール'},
  'password': {'en': 'Password', 'zh': '密码', 'es': 'Contraseña', 'hi': 'पासवर्ड', 'fr': 'Mot de passe', 'ar': 'كلمة المرور', 'ru': 'Пароль', 'ja': 'パスワード'},
  'forgot_password': {'en': 'Forgot Password?', 'zh': '忘记密码？', 'es': '¿Olvidaste tu contraseña?', 'hi': 'पासवर्ड भूल गए?', 'fr': 'Mot de passe oublié?', 'ar': 'نسيت كلمة المرور؟', 'ru': 'Забыли пароль?', 'ja': 'パスワードをお忘れですか？'},
  
  // Data Usage
  'messages_sent': {'en': 'Messages Sent', 'zh': '发送的消息', 'es': 'Mensajes Enviados', 'hi': 'भेजे गए संदेश', 'fr': 'Messages envoyés', 'ar': 'الرسائل المرسلة', 'ru': 'Отправлено сообщений', 'ja': '送信メッセージ'},
  'messages_received': {'en': 'Messages Received', 'zh': '收到的消息', 'es': 'Mensajes Recibidos', 'hi': 'प्राप्त संदेश', 'fr': 'Messages reçus', 'ar': 'الرسائل المستلمة', 'ru': 'Получено сообщений', 'ja': '受信メッセージ'},
  'photos_shared': {'en': 'Photos Shared', 'zh': '分享的照片', 'es': 'Fotos Compartidas', 'hi': 'साझा की गई फ़ोटो', 'fr': 'Photos partagées', 'ar': 'الصور المشاركة', 'ru': 'Поделено фото', 'ja': '共有した写真'},
  
  // Misc
  'language_changed': {'en': 'Language Changed', 'zh': '语言已更改', 'es': 'Idioma Cambiado', 'hi': 'भाषा बदली गई', 'fr': 'Langue modifiée', 'ar': 'تم تغيير اللغة', 'ru': 'Язык изменен', 'ja': '言語が変更されました'},
  'light_mode': {'en': 'Light mode goes all in on clarity and warmth.', 'zh': '浅色模式注重清晰度和温暖感。', 'es': 'El modo claro apuesta por la claridad y calidez.', 'hi': 'लाइट मोड स्पष्टता और गर्माहट पर केंद्रित है।', 'fr': 'Le mode clair mise sur la clarté et la chaleur.', 'ar': 'الوضع الفاتح يركز على الوضوح والدفء.', 'ru': 'Светлый режим делает упор на ясность и теплоту.', 'ja': 'ライトモードは明快さと温かみを重視します。'},
  'dark_mode': {'en': 'Dark mode goes easy on the eyes.', 'zh': '深色模式更护眼。', 'es': 'El modo oscuro es más fácil para los ojos.', 'hi': 'डार्क मोड आंखों पर आसान है।', 'fr': 'Le mode sombre est plus doux pour les yeux.', 'ar': 'الوضع الداكن أسهل على العيون.', 'ru': 'Темный режим приятен для глаз.', 'ja': 'ダークモードは目に優しいです。'},
  'verified': {'en': 'Verified', 'zh': '已验证', 'es': 'Verificado', 'hi': 'सत्यापित', 'fr': 'Vérifié', 'ar': 'موثق', 'ru': 'Подтверждено', 'ja': '確認済み'},
  'online': {'en': 'Online', 'zh': '在线', 'es': 'En línea', 'hi': 'ऑनलाइन', 'fr': 'En ligne', 'ar': 'متصل', 'ru': 'Онлайн', 'ja': 'オンライン'},
  'offline': {'en': 'Offline', 'zh': '离线', 'es': 'Desconectado', 'hi': 'ऑफ़लाइन', 'fr': 'Hors ligne', 'ar': 'غير متصل', 'ru': 'Оффлайн', 'ja': 'オフライン'},
  'blocked_users': {'en': 'Blocked Users', 'zh': '已屏蔽用户', 'es': 'Usuarios Bloqueados', 'hi': 'ब्लॉक किए गए उपयोगकर्ता', 'fr': 'Utilisateurs bloqués', 'ar': 'المستخدمون المحظورون', 'ru': 'Заблокированные', 'ja': 'ブロックされたユーザー'},
  'discovery_preferences': {'en': 'Discovery Preferences', 'zh': '发现偏好', 'es': 'Preferencias de Descubrimiento', 'hi': 'खोज प्राथमिकताएं', 'fr': 'Préférences de découverte', 'ar': 'تفضيلات الاكتشاف', 'ru': 'Настройки поиска', 'ja': 'ディスカバリー設定'},
  'manage_messages': {'en': 'Manage Messages', 'zh': '管理消息', 'es': 'Administrar Mensajes', 'hi': 'संदेश प्रबंधित करें', 'fr': 'Gérer les messages', 'ar': 'إدارة الرسائل', 'ru': 'Управление сообщениями', 'ja': 'メッセージ管理'},
  'read_receipts': {'en': 'Read Receipts', 'zh': '已读回执', 'es': 'Confirmaciones de Lectura', 'hi': 'पढ़ने की रसीदें', 'fr': 'Confirmations de lecture', 'ar': 'إيصالات القراءة', 'ru': 'Отчеты о прочтении', 'ja': '既読確認'},
  'direct_messages': {'en': 'Direct Messages', 'zh': '私信', 'es': 'Mensajes Directos', 'hi': 'सीधे संदेश', 'fr': 'Messages directs', 'ar': 'الرسائل المباشرة', 'ru': 'Личные сообщения', 'ja': 'ダイレクトメッセージ'},
};

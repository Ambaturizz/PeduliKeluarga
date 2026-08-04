enum AppRoute {
  onboarding(
    name: 'onboarding',
    path: '/onboarding',
  ),
  login(
    name: 'login',
    path: '/login',
  ),
  register(
    name: 'register',
    path: '/register',
  ),
  termsConditions(
    name: 'termsConditions',
    path: '/terms-conditions',
  ),
  privacyPolicy(
    name: 'privacyPolicy',
    path: '/privacy-policy',
  ),
  home(
    name: 'home',
    path: '/',
  ),
  peduliCek(
    name: 'peduliCek',
    path: '/pedulicek',
  ),
  peduliObat(
    name: 'peduliObat',
    path: '/peduliobat',
  ),
  familyAlert(
    name: 'familyAlert',
    path: '/family-alert',
  ),
  ahliPeduli(
    name: 'ahliPeduli',
    path: '/ahli-peduli',
  ),
  peduliRiwayat(
    name: 'peduliRiwayat',
    path: '/peduliriwayat',
  ),
  peduliAntar(
    name: 'peduliAntar',
    path: '/peduli-antar',
  ),
  peduliKonsul(
    name: 'peduliKonsul',
    path: '/peduli-konsul',
  ),
  familyChat(
    name: 'familyChat',
    path: '/family-chat',
  ),
  peduliPantau(
    name: 'peduliPantau',
    path: '/peduli-pantau',
  ),
  notifications(
    name: 'notifications',
    path: '/notifications',
  ),
  profile(
    name: 'profile',
    path: '/profile',
  ),
  settings(
    name: 'settings',
    path: '/settings',
  ),
  peduliDiri(
    name: 'peduliDiri',
    path: '/peduli-diri',
  ),
  peduliLiterasi(
    name: 'peduliLiterasi',
    path: '/peduli-literasi',
  ),
  aiInsight(
    name: 'aiInsight',
    path: '/ai-insight',
  ),
  familyManagement(
    name: 'familyManagement',
    path: '/family-management',
  );

  const AppRoute({
    required this.name,
    required this.path,
  });

  final String name;
  final String path;
}

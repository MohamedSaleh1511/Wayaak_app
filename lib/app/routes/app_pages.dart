import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:wayaak/app/modules/add_order/bindings/add_order_binding.dart';
import 'package:wayaak/app/modules/auth/pages/choose_user_type.dart';
import 'package:wayaak/app/modules/auth/pages/reset_password.dart';
import 'package:wayaak/app/modules/coupons/bindings/coupons_binding.dart';
import 'package:wayaak/app/modules/coupons/views/coupon_view.dart';
import 'package:wayaak/app/modules/home/bindings/guest_binding.dart';
import 'package:wayaak/app/modules/home/views/guest_view.dart';
import 'package:wayaak/app/modules/home/views/search_page.dart';
import 'package:wayaak/app/modules/add_order/views/add_order_view.dart';
import 'package:wayaak/app/modules/add_order/views/checkout_webview.dart';
import 'package:wayaak/app/modules/add_order/views/offers_view.dart';
import 'package:wayaak/app/modules/orders/views/order_details_view.dart';
import 'package:wayaak/app/modules/profile/views/change_pass.dart';
import 'package:wayaak/app/modules/profile/views/edit_profile_view.dart';
import 'package:wayaak/app/modules/saved_locations/views/add_location_view.dart';
import 'package:wayaak/app/modules/static_pages/bindings/static_pages_binding.dart';
import 'package:wayaak/app/modules/static_pages/pages/about_us_page.dart';
import 'package:wayaak/app/modules/static_pages/pages/contact_us_page.dart';
import 'package:wayaak/app/modules/static_pages/pages/privacy_policy_page.dart';
import 'package:wayaak/app/modules/static_pages/pages/terms_conditions_page.dart';
import 'package:wayaak/app/modules/support/views/add_ticket_view.dart';
import 'package:wayaak/app/modules/support/views/faqs_view.dart';
import 'package:wayaak/app/modules/support/views/ticket_chat_view.dart';
import 'package:wayaak/app/modules/support/views/tickets_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/pages/forget_pass.dart';
import '../modules/auth/pages/login.dart';
import '../modules/auth/pages/otp_code.dart';
import '../modules/auth/pages/signup.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_messages_view.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/language/bindings/language_binding.dart';
import '../modules/language/views/language_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/onboarding/onboarding_binding.dart';
import '../modules/onboarding/onboarding_page.dart';
import '../modules/onboarding/welcome_page.dart';
import '../modules/orders/bindings/orders_binding.dart';
import '../modules/orders/views/orders_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profits/bindings/profits_binding.dart';
import '../modules/reviews/bindings/reviews_binding.dart';
import '../modules/reviews/views/reviews_view.dart';
import '../modules/saved_locations/bindings/saved_locations_binding.dart';
import '../modules/saved_locations/views/saved_locations_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_page.dart';
import '../modules/support/bindings/support_binding.dart';
import '../modules/support/views/support_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = '/splash';

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.welcome,
      page: () => const WelcomePage(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      bindings: [
        AuthBinding(),
        StaticPagesBinding(),
      ],
    ),
    GetPage(
      name: Routes.chooseUserType,
      page: () => const ChooseUserType(),
      bindings: [
        AuthBinding(),
        StaticPagesBinding(),
      ],
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignupPage(),
      bindings: [
        AuthBinding(),
        StaticPagesBinding(),
      ],
    ),
    GetPage(
      name: Routes.forgetPass,
      page: () => const ForgetPassPage(),
      bindings: [
        AuthBinding(),
        StaticPagesBinding(),
      ],
    ),
    GetPage(
      name: Routes.resetPass,
      page: () => const ResetPassword(),
      bindings: [
        AuthBinding(),
        StaticPagesBinding(),
      ],
    ),
    GetPage(
      name: Routes.otpCode,
      page: () => const OtpCodePage(),
      bindings: [
        AuthBinding(),
        StaticPagesBinding(),
      ],
    ),
    GetPage(
      name: Routes.main,
      page: () => const HomeView(),
      bindings: [
        HomeBinding(),
        OrdersBinding(),
        ChatBinding(),
        ProfileBinding(),
        StaticPagesBinding(),
        SupportBinding(),
      ],
    ),
    GetPage(
      name: Routes.search,
      page: () => const SearchPage(),
      bindings: [
        HomeBinding(),
        OrdersBinding(),
      ],
    ),
    GetPage(
      name: Routes.chat,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.chatMessages,
      page: () => const ChatMessagesView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.orders,
      page: () => const OrdersView(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
    ),
    GetPage(
      name: Routes.changePass,
      page: () => const ChangesPassword(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.notification,
      page: () => const NotificationView(),
      bindings: [
        NotificationBinding(),
        SupportBinding(),
      ],
    ),
    GetPage(
      name: Routes.savedLocations,
      page: () => const SavedLocationsView(),
      bindings: [
        SavedLocationsBinding(),
        AddOrderBinding(),
        CouponsBinding(),
      ],
    ),
    GetPage(
      name: Routes.addLocation,
      page: () => const AddLocationView(),
      binding: SavedLocationsBinding(),
    ),
    GetPage(
      name: Routes.reviews,
      page: () => const ReviewsView(),
      binding: ReviewsBinding(),
    ),
    GetPage(
      name: Routes.support,
      page: () => const SupportView(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: Routes.tickets,
      page: () => const TicketsView(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: Routes.ticketChat,
      page: () => const TicketChatView(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: Routes.addTicket,
      page: () => const AddTicketView(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: Routes.language,
      page: () => const LanguageView(),
      binding: LanguageBinding(),
    ),
    GetPage(
      name: Routes.editProfile,
      page: () => const EditProfileView(),
      binding: ProfitsBinding(),
    ),
    GetPage(
      name: Routes.addOrder,
      page: () => const AddOrderView(),
      bindings: [
        AddOrderBinding(),
        CouponsBinding(),
      ],
    ),
    GetPage(
      name: Routes.orderDetails,
      page: () => const OrderDetailsView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.checkout,
      page: () => const CheckoutWebview(),
      bindings: [
        AddOrderBinding(),
        CouponsBinding(),
      ],
    ),
    GetPage(
      name: Routes.offers,
      page: () => const OffersView(),
      bindings: [
        AddOrderBinding(),
        CouponsBinding(),
      ],
    ),
    GetPage(
      name: Routes.coupons,
      page: () => const CouponsView(),
      binding: CouponsBinding(),
    ),
    GetPage(
      name: Routes.about,
      page: () => const AboutUsPage(),
      binding: StaticPagesBinding(),
    ),
    GetPage(
      name: Routes.terms,
      page: () => const TermsAndConditions(),
      binding: StaticPagesBinding(),
    ),
    GetPage(
      name: Routes.privacy,
      page: () => const PrivacyPolicy(),
      binding: StaticPagesBinding(),
    ),
    GetPage(
      name: Routes.faq,
      page: () => const FaqsView(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: Routes.guest,
      page: () => const GuestView(),
      binding: GuestBinding(),
    ),
    GetPage(
      name: Routes.contact,
      page: () => const ContactUsPage(),
      binding: StaticPagesBinding(),
    ),
  ];
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wayaak/app/core/widgets/global_appbar.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/data/services/app_services.dart';
import 'package:wayaak/app/modules/notification/controllers/notification_controller.dart';
import 'package:wayaak/app/modules/profile/controllers/profile_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../../core/theme/theme.dart';
import '../../../routes/app_routes.dart';
// import '../../../core/widgets/global_button.dart';
// import '../../notification/widgets/rating_dialog.dart';

class CheckoutWebview extends StatefulWidget {
  const CheckoutWebview({super.key});

  @override
  State<CheckoutWebview> createState() => _CheckoutWebviewState();
}

class _CheckoutWebviewState extends State<CheckoutWebview> {
  late final WebViewController _controller;
  bool paymentProcessStarted = false;

  int index = 0;
  bool success = false;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color.fromARGB(0, 255, 255, 255))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            Get.log("Page URL :: $url");
          },
          onPageFinished: (String url) {
            Get.log("onPageFinished: $url");
            bool isFinished = url.contains("callback") &&
                url.toLowerCase().contains("paymentstatus");
            if (isFinished) {
              if (!paymentProcessStarted) {
                paymentProcessStarted = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {});
                  }
                });
              }
            }
            if (isFinished) {
              Get.log("Page Finished -- ${Get.arguments}");
              if (url.toLowerCase().contains('success')) {
                Get.log("Success ${Get.arguments == 'Payment'}");

                if (Get.arguments == 'Wallet') {
                  Get.back();
                  Get.find<ProfileController>().getAccountBalance();
                } else if (Get.arguments == 'Payment') {
                  // Ui.successGetBar(message: 'Payment');
                  // Get.back();

                  Get.offNamed(Routes.orderDetails);
                  // Get.find<HomeController>().updateTransaction(
                  //   Get.find<HomeController>().trancMessageAr.value,
                  //   Get.find<HomeController>().trancMessageEn.value,
                  // );
                  Get.find<NotificationController>().getNotifications();
                }

                Get.find<NotificationController>()
                    .markAsRead(Get.find<AppServices>().notificationId.value);
              }
            }
          },
          onUrlChange: (u) {
            Get.log("uuu $u");
          },
          onHttpError: (HttpResponseError error) {
            Get.log("HTTP Error");
          },
          onWebResourceError: (WebResourceError error) {
            Get.log("Http Resource error");
          },
          onNavigationRequest: (NavigationRequest request) {
            Get.log("request: ${request.url}");
            if (request.url.startsWith('https://www.google.com')) {
              Get.log("Google Navigation");
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..setOnConsoleMessage(
        (message) {
          Get.log("message: $message");
        },
      )
      ..loadRequest(Uri.parse(Get.find<AppServices>().webViewUrl.value));
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please complete the payment process'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Scaffold(
        appBar: GlobalAppbar(
            leading: IconButton(
              onPressed: () {
                if (paymentProcessStarted) {
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please complete the payment process'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              icon: Transform.flip(
                flipX: Get.locale == const Locale('ar'),
                child: 'Arrow Back'.iconColored(),
              ),
            ),
            title: (Get.arguments != null)
                ? Get.arguments.toString().tr
                : 'Checkout'.tr),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}

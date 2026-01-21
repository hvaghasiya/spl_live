import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get_storage/get_storage.dart';
import '../../helper_files/app_colors.dart';
import '../../helper_files/constant_variables.dart';
import '../../models/commun_models/user_details_model.dart';

// Add these two imports
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:image_picker/image_picker.dart';

class ChatWebViewScreen extends StatefulWidget {
  const ChatWebViewScreen({super.key});

  @override
  State<ChatWebViewScreen> createState() => _ChatWebViewScreenState();
}

class _ChatWebViewScreenState extends State<ChatWebViewScreen> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    String userName = "Guest";
    String userId = "";
    String userPhone = "";
    String userEmail = "";

    try {
      final box = GetStorage();
      final storedData = box.read(ConstantsVariables.userData);

      if (storedData != null) {
        UserDetailsModel user = UserDetailsModel.fromJson(storedData);

        userName = user.userName ?? user.fullName ?? "User";
        userId = user.id.toString();
        userPhone = user.phoneNumber ?? "";
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }

    final String htmlContent = '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, interactive-widget=resizes-content">
        <style>
           body, html { 
             margin: 0; 
             padding: 0; 
             height: 100%; 
             width: 100%; 
             overflow: hidden; 
             background-color: #ffffff;
           }
           #fc_frame, iframe {
             position: absolute !important;
        top: -29px !important; 
            height: calc(100% + 40px) !important; 
             width: 100% !important;
             margin: 0 !important;
             box-shadow: none !important; 
             border-radius: 0 !important;
             z-index: 9999 !important;
           }
           .fc-launcher-ring, .fc-launcher-ring-container { 
              display: none !important;
           }
        </style>
      </head>
      <body>
      
      <script 
          src='https://in.fw-cdn.com/32681001/1502620.js' 
          chat='true' 
          widgetId='118ae25b-7532-4756-a1cd-e6d5687c4af2'>
        </script>
        
        <script>
          var interval = setInterval(function() {
            if (window.fcWidget) {
              clearInterval(interval);
              
              var userData = {
                firstName: "$userName",
                email: "$userEmail",    
                phone: "$userPhone",     
                externalId: "$userId"    
              };

              window.fcWidget.init({
                host: "https://wchat.in.freshchat.com",
                widgetId: "118ae25b-7532-4756-a1cd-e6d5687c4af2",
                externalId: userData.externalId,
                firstName: userData.firstName,
                phone: userData.phone,
                email: userData.email, 
                config: {
                  headerProperty: {
                    hideChatButton: true, 
                    direction: 'ltr'
                  },
                  showFAQOnOpen: true 
                }
              });

              window.fcWidget.user.setProperties({
                firstName: userData.firstName,
                phone: userData.phone,
                email: userData.email,
                externalId: userData.externalId
              });

              window.fcWidget.open();
              
              window.fcWidget.on('widget:closed', function() {
                window.fcWidget.open();
              });
            }
          }, 500);
        </script>
      </body>
      </html>
    ''';
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          },
        ),
      );

    if (_controller.platform is AndroidWebViewController) {
      final AndroidWebViewController androidController =
          _controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
      androidController
          .setOnShowFileSelector((FileSelectorParams params) async {
        final picker = ImagePicker();
        XFile? file;
        try {
          file = await picker.pickImage(source: ImageSource.gallery);
        } catch (e) {
          print("Error picking file: $e");
        }

        if (file == null) {
          return [];
        }
        return [Uri.file(file.path).toString()];
      });
    }
    _controller.loadHtmlString(htmlContent,
        baseUrl: "https://wchat.in.freshchat.com");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Center(
            child: Text("Support Chat",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.appbarColor,
        elevation: 1,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

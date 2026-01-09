import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import '../models/commun_models/user_details_model.dart';

void attachFreshchatUser(UserDetailsModel userData) {
  FreshchatUser user = FreshchatUser(
    userData.id.toString(),
    "",
  );

  user.setFirstName(userData.userName ?? "User");

  if (userData.phoneNumber != null && userData.phoneNumber!.isNotEmpty) {
    user.setPhone(
      userData.phoneNumber!,
      userData.countryCode ?? "91",
    );
  }

  Freshchat.setUser(user);
}

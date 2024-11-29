import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../../core/class/staterequest.dart';
import '../../data/dataresource/home_page_data/check_in_data.dart';

abstract class CheckInController extends GetxController {
  Future<void> checkIn(List<int> fileIds);
}

class CheckInControllerImp extends CheckInController {
  final CheckInData checkInData;
  final int groupId;
  StatusRequest? statusRequest;

  CheckInControllerImp(this.checkInData, this.groupId);

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<void> checkIn(List<int> fileIds) async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      // Call the postMultipart function to get the response
      var response = await checkInData.postMultipart(fileIds, groupId);

      // Check if the response is a 'Right' containing the actual data
      if (response is Right) {
        var responseData = response.value; // Access the data inside 'Right'

        if (responseData is Map && responseData.containsKey('message')) {
          String message = responseData['message']; // Extract the message

          // If the message is "Files reserved successfully", show a success message
          if (message == "Files reserved successfully") {
            statusRequest = StatusRequest.success;
            Get.snackbar("Success", message); // Display success message
            print("Response: $responseData");
          }
          // If the message indicates files are already reserved or taken
          else if (message == "One or more files are already reserved or taken") {
            statusRequest = StatusRequest.failure;
            Get.snackbar("Reservation Error", message); // Display reservation error message
            print("Response error: $message");
          } else {
            // Handle any other server messages
            statusRequest = StatusRequest.failure;
            Get.snackbar("Error", message); // Display any other server message
            print("Unexpected response: $responseData");
          }
        } else {
          // If the response format is not as expected
          statusRequest = StatusRequest.failure;
          Get.snackbar("Error", "Unexpected response format.");
          print("Unexpected response format: $response");
        }
      } else {
        // In case the response is not of type 'Right', handle it as an error
        statusRequest = StatusRequest.failure;
        Get.snackbar("Error", "Unexpected response received.");
        print("Unexpected response: $response");
      }
    } catch (e) {
      // Handle any exceptions during the request
      statusRequest = StatusRequest.failure;
      print("Error occurred: $e");
      Get.snackbar("Error", "An unexpected error occurred.");
    } finally {
      update();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

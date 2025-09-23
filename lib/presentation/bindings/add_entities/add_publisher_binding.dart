import 'package:book_store_admin/data/datasources/publisher_datasource.dart';
import 'package:book_store_admin/presentation/controllers/add_entities/add_publisher_controller.dart';
import 'package:get/get.dart';

class AddPublisherBinding {
  static void init() {
    Get.lazyPut(
      () => AddPublisherController(
        publisherDatasource: Get.find<PublisherDatasource>(),
      ),
    );
  }
}

package com.sqt.send_me_pic

import io.flutter.embedding.android.FlutterActivity

import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES

class MainActivity: FlutterActivity() {
    private val CHANNEL = "channel:me.albie.save/download"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "saveImage") {

                val image = call.argument<ByteArray>("imageBytes")
                val name = call.argument<String>("name")

                print("FROM ANDRODI");
                print(image);
                print(name);

            } else {
                result.notImplemented()
            }
        }
    }
}

//fun FlutterActivity.insertImage(
//        source: Bitmap?,
//        title: String,
//        description: String
//) {
//    val values = ContentValues()
//    values.put(Images.Media.TITLE, title)
//    values.put(Images.Media.DISPLAY_NAME, title)
//    values.put(Images.Media.DESCRIPTION, description)
//    values.put(Images.Media.MIME_TYPE, "image/*")
//    // Add the date meta data to ensure the image is added at the front of the gallery
//    values.put(Images.Media.DATE_ADDED, System.currentTimeMillis())
//
//    var url: Uri? = null
//    var stringUrl: String? = null / value to be returned /
//
//    try {
//        url = contentResolver.insert(Images.Media.EXTERNAL_CONTENT_URI, values)
//        if (source != null) {
//            val imageOut: OutputStream? = contentResolver.openOutputStream(url!!)
//            imageOut.use { imageOut ->
//                source.compress(Bitmap.CompressFormat.JPEG, 50, imageOut)
//            }
//        } else {
//            contentResolver.delete(url!!, null, null)
//            url = null
//        }
//    } catch (e: Exception) {
//        if (url != null) {
//            contentResolver.delete(url, null, null)
//            url = null
//        }
//    }
//
//    if (url != null) {
//        stringUrl = url.toString()
//    }
//}
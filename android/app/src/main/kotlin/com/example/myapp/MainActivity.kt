package com.example.myapp

import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.nio.file.Files
import java.nio.file.Paths

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.myapp/filesystem"

    @RequiresApi(Build.VERSION_CODES.O)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getFileSystemType") {
                val path = call.argument<String>("path")
                if (path != null) {
                    try {
                        val fileStore = Files.getFileStore(Paths.get(path))
                        result.success(fileStore.type())
                    } catch (e: Exception) {
                        result.error("UNAVAILABLE", "File system type not available: ${e.message}", null)
                    }
                } else {
                    result.error("INVALID_ARGUMENT", "Path not provided.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}

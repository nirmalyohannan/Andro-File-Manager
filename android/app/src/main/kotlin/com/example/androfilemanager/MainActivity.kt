package com.example.androfilemanager

import android.app.usage.StorageStatsManager
import android.content.Context
import android.os.StatFs
import android.os.storage.StorageManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.UUID

class MainActivity : FlutterActivity() {

    private val channel = "DiskSpace"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
                call,
                result ->
            if (call.method == "getInternalTotalSpace") {
                result.success(getInternalTotalSpace())
            } else if (call.method == "getInteralFreeSpace") {
                result.success(getInternalFreeSpace())
            } else if (call.method == "getExternalTotalSpace") {
                result.success(getExternalTotalSpace())
            } else if (call.method == "getExternalFreeSpace") {
                result.success(getExternalFreeSpace())
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getInternalTotalSpace(): Long {
        // val statFs = StatFs("/storage/emulated/")
        // val bytesTotal: Long = statFs.blockSizeLong * statFs.blockCountLong
        // return Formatter.formatFileSize(context, statFs.totalBytes)
        /// ----------------------------------------------
        // --------Getting primary Volume----------//
        var totalBytes: Long
        val storageManager = getSystemService(Context.STORAGE_SERVICE) as StorageManager // 🥳🥳🥳
        val storageVolume = storageManager.primaryStorageVolume
        // -------Getting UUID---------//
        val uuidStr = storageVolume.uuid
        val uuid = if (uuidStr == null) StorageManager.UUID_DEFAULT else UUID.fromString(uuidStr)
        // ---------Initiating StorageStatsManager---------//
        val storageStatsManager =
                getSystemService(Context.STORAGE_STATS_SERVICE) as StorageStatsManager

        totalBytes =
                storageStatsManager.getTotalBytes(
                        uuid
                ) // getting total size by passing Storage UUID
        // -------Formatting and returning result-------//

        // Log.d(
        //         "AppLog",
        //         "storageVolume \"${storageVolume.getDescription(this)}\" - $formattedResult"
        // )

        return totalBytes
    }

    fun getInternalFreeSpace(): Long {
        // val statFs = StatFs(Environment.getDataDirectory().absolutePath)
        // val bytesAvailable: Long = statFs.blockSizeLong * statFs.availableBlocksLong
        // return Formatter.formatFileSize(context, statFs.freeBytes)
        // --------------------------------------------------------------
        // --------Getting primary Volume----------//

        var availableBytes: Long
        val storageManager = getSystemService(Context.STORAGE_SERVICE) as StorageManager // 🥳🥳🥳
        val storageVolume = storageManager.primaryStorageVolume
        // -------Getting UUID---------//
        val uuidStr = storageVolume.uuid
        val uuid = if (uuidStr == null) StorageManager.UUID_DEFAULT else UUID.fromString(uuidStr)
        // ---------Initiating StorageStatsManager---------//
        val storageStatsManager =
                getSystemService(Context.STORAGE_STATS_SERVICE) as StorageStatsManager

        availableBytes =
                storageStatsManager.getFreeBytes(uuid) // getting total size by passing Storage UUID
        // -------Formatting and returning result-------//

        // Log.d(
        //         "AppLog",
        //         "storageVolume \"${storageVolume.getDescription(this)}\" - $formattedResult"
        // )

        return availableBytes
    }

    fun getExternalTotalSpace(): Long {
        // val statFs = StatFs(Environment.getExternalStorageDirectory().absolutePath)
        // val bytesTotal: Long = statFs.blockSizeLong * statFs.blockCountLong

        // return bytesTotal.toString()
        // ------------------------------------------------------------------------//
        // --------Getting Volumes List----------//
        var totalBytes: Long = 0
        val storageManager =
                getSystemService(Context.STORAGE_SERVICE) as
                        StorageManager // Initiating Storage Manager Class
        val storageVolumes = storageManager.getStorageVolumes()
        for (storageVolume in storageVolumes) {
            if (storageVolume.isPrimary == false) { // If the volume is not primary
                val statFs = StatFs(storageVolume.getDirectory()!!.absolutePath)
                totalBytes = statFs.totalBytes
            }
        }
        // Log.d("AppLog", "Storage volumes count: ${storageVolumes.lastIndex}")
        return totalBytes
    }

    fun getExternalFreeSpace(): Long {
        // val statFs = StatFs(Environment.getExternalStorageDirectory().absolutePath)
        // val bytesAvailable: Long = statFs.blockSizeLong * statFs.availableBlocksLong

        // return bytesAvailable.toString() + Environment.getExternalStorageDirectory().absolutePath
        // ---------------------------------------------------------------------
        var availableBytes: Long = 0
        val storageManager =
                getSystemService(Context.STORAGE_SERVICE) as
                        StorageManager // Initiating Storage Manager Class
        val storageVolumes = storageManager.getStorageVolumes()
        for (storageVolume in storageVolumes) {
            if (storageVolume.isPrimary == false) { // If the volume is not primary
                val statFs = StatFs(storageVolume.getDirectory()!!.absolutePath)
                availableBytes = statFs.availableBytes
            }
        }
        // Log.d("AppLog", "Storage volumes count: ${storageVolumes.lastIndex}")
        return availableBytes
    }
    // -----------------::::::::::::::::::::::------------------------------

}

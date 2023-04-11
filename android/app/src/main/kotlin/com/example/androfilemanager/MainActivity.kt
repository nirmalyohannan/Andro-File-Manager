package com.example.androfilemanager

import android.app.usage.StorageStatsManager
import android.content.Context
import android.database.Cursor
import android.net.Uri
import android.os.Environment
import android.os.StatFs
import android.os.storage.StorageManager
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.UUID

class MainActivity : FlutterFragmentActivity() {

    private val channel_1 = "Storage"
    private val channel_2 = "Android"
    private val channel_3 = "Media"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel_1).setMethodCallHandler {
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
            } else if (call.method == "getInternalPath") {
                val path: String = Environment.getExternalStorageDirectory().path
                result.success(path)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel_2).setMethodCallHandler {
                call,
                result ->
            if (call.method == "getAndroidVersionInt") {

                result.success(android.os.Build.VERSION.SDK_INT)
            } else {
                result.notImplemented()
            }
        }
        // -------------
        MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), channel_3)
                .setMethodCallHandler { call, result ->
                    if (call.method.equals("getMedias")) {
                        val medias: ArrayList<String> = ArrayList<String>()
                        val projection: Array<String>
                        val type: String? = call.argument("type") ?: ""
                        if (type == "MediaType.image") {
                            projection = arrayOf(MediaStore.Images.Media.DATA)
                            val uri: Uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
                            val cursor: Cursor? =
                                    getContentResolver().query(uri, projection, null, null, null)
                            if (cursor != null) {
                                while (cursor.moveToNext()) {
                                    val imagePath: String =
                                            cursor.getString(
                                                    cursor.getColumnIndexOrThrow(
                                                            MediaStore.Images.Media.DATA
                                                    )
                                            )
                                    medias.add(imagePath)
                                }
                                cursor.close()
                            }
                        } else if (type == "MediaType.audio") {
                            projection = arrayOf(MediaStore.Audio.Media.DATA)
                            val uri: Uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
                            val cursor: Cursor? =
                                    getContentResolver().query(uri, projection, null, null, null)
                            if (cursor != null) {
                                while (cursor.moveToNext()) {
                                    val imagePath: String =
                                            cursor.getString(
                                                    cursor.getColumnIndexOrThrow(
                                                            MediaStore.Audio.Media.DATA
                                                    )
                                            )
                                    medias.add(imagePath)
                                }
                                cursor.close()
                            }
                        } else if (type == "MediaType.document") {
                            projection = arrayOf(MediaStore.Files.FileColumns.DATA)
                            val uri: Uri = MediaStore.Files.getContentUri("external")
                            val selection: String = MediaStore.Files.FileColumns.MIME_TYPE + "=?"
                            val selectionArgs: Array<String> =
                                    arrayOf(
                                            "application/pdf",
                                            // "application/epub+zip",
                                            // "application/msword",
                                            // "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                                            // "text/plain"
                                            )
                            val cursor: Cursor? =
                                    getContentResolver()
                                            .query(uri, projection, selection, selectionArgs, null)
                            if (cursor != null) {
                                while (cursor.moveToNext()) {
                                    val imagePath: String =
                                            cursor.getString(
                                                    cursor.getColumnIndexOrThrow(
                                                            MediaStore.Audio.Media.DATA
                                                    )
                                            )
                                    medias.add(imagePath)
                                }
                                cursor.close()
                            }
                        } else if (type == "MediaType.app") {
                            projection = arrayOf(MediaStore.Files.FileColumns.DATA)
                            val uri: Uri = MediaStore.Files.getContentUri("external")
                            val selection: String = MediaStore.Files.FileColumns.MIME_TYPE + "=?"
                            val selectionArgs: Array<String> =
                                    arrayOf(
                                            "application/vnd.android.package-archive",
                                    )
                            val cursor: Cursor? =
                                    getContentResolver()
                                            .query(uri, projection, selection, selectionArgs, null)
                            if (cursor != null) {
                                while (cursor.moveToNext()) {
                                    val imagePath: String =
                                            cursor.getString(
                                                    cursor.getColumnIndexOrThrow(
                                                            MediaStore.Audio.Media.DATA
                                                    )
                                            )
                                    medias.add(imagePath)
                                }
                                cursor.close()
                            }
                        } else {
                            projection = arrayOf(MediaStore.Video.Media.DATA)
                            val uri: Uri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI
                            val cursor: Cursor? =
                                    getContentResolver().query(uri, projection, null, null, null)
                            if (cursor != null) {
                                while (cursor.moveToNext()) {
                                    val imagePath: String =
                                            cursor.getString(
                                                    cursor.getColumnIndexOrThrow(
                                                            MediaStore.Video.Media.DATA
                                                    )
                                            )
                                    medias.add(imagePath)
                                }
                                cursor.close()
                            }
                        }

                        result.success(medias)
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

package org.example.detectapp

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageCapture
import androidx.camera.core.ImageCaptureException
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.content.ContextCompat.getMainExecutor
import android.content.Intent
import android.widget.Button

import java.io.File
import java.text.SimpleDateFormat
import java.util.Locale
import java.io.IOException
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.RequestBody.Companion.asRequestBody
import okhttp3.OkHttpClient
import okhttp3.MultipartBody
import okhttp3.Request
import okhttp3.Callback
import okhttp3.Call
import okhttp3.Response


class MainActivity : AppCompatActivity() {
    private lateinit var server: ESPHttpServer
    private lateinit var imageCapture: ImageCapture

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        findViewById<Button>(R.id.settingsButton)?.setOnClickListener {
            startActivity(Intent(this, SettingsActivity::class.java))
        }
        // Ask for camera permission
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
            != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CAMERA), 100)
        } else {
            startCamera()
        }

        // Start NanoHTTPD server
        server = ESPHttpServer(8080) { command ->
            if (command == "take_pic") {
                runOnUiThread { takePicture() }
            }
        }
        server.start()
    }

    private fun startCamera() {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)

        cameraProviderFuture.addListener({
            val cameraProvider = cameraProviderFuture.get()

            imageCapture = ImageCapture.Builder().build()

            val cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA

            try {
                cameraProvider.unbindAll()
                cameraProvider.bindToLifecycle(
                    this, cameraSelector, imageCapture
                )
                Log.d("CAMERA", "✅ Camera initialized")
            } catch (exc: Exception) {
                Log.e("CAMERA", "Use case binding failed", exc)
            }
        }, getMainExecutor(this))
    }

    private fun takePicture() {
        if (!::imageCapture.isInitialized) {
            Log.e("CAMERA", "❌ Camera not ready yet")
            return
        }

        val photoFile = File(
            getExternalFilesDir(null),
            SimpleDateFormat("yyyyMMdd-HHmmss", Locale.US)
                .format(System.currentTimeMillis()) + ".jpg"
        )

        val outputOptions = ImageCapture.OutputFileOptions.Builder(photoFile).build()

        imageCapture.takePicture(
            outputOptions,
            getMainExecutor(this),
            object : ImageCapture.OnImageSavedCallback {
                override fun onError(exc: ImageCaptureException) {
                    Log.e("CAMERA", "❌ Photo capture failed: ${exc.message}", exc)
                }

                override fun onImageSaved(output: ImageCapture.OutputFileResults) {
                    Log.d("CAMERA", "📸 Picture saved: ${photoFile.absolutePath}")
                    uploadFile(photoFile)
                }
            }
        )
    }
    private fun uploadFile(photoFile: File) {
        val prefs = getSharedPreferences("app_prefs", MODE_PRIVATE)
        val serverUrl = prefs.getString("server_url", null)

        if (serverUrl.isNullOrEmpty()) {
            Log.e("UPLOAD", "❌ No server URL configured. Please set it in settings.")
            return
        }

        val client = OkHttpClient()

        val requestBody = MultipartBody.Builder()
            .setType(MultipartBody.FORM)
            .addFormDataPart(
                "file",
                photoFile.name,
                photoFile.asRequestBody("image/jpeg".toMediaTypeOrNull())
            )
            .build()

        val request = Request.Builder()
            .url(serverUrl)
            .post(requestBody)
            .build()

        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                Log.e("UPLOAD", "❌ Upload failed: ${e.message}", e)
            }

            override fun onResponse(call: Call, response: Response) {
                if (response.isSuccessful) {
                    Log.d("UPLOAD", "✅ Upload success: ${response.body?.string()}")
                } else {
                    Log.e("UPLOAD", "❌ Upload error: ${response.code}")
                }
            }
        })
    }

    override fun onDestroy() {
        super.onDestroy()
        server.stop()
    }
}

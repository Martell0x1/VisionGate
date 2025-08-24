package org.example.detectapp

import android.content.Context
import android.net.wifi.WifiManager
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class SettingsActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_settings)

        val ipText = findViewById<TextView>(R.id.ipTextView)
        val serverIpInput = findViewById<EditText>(R.id.editIp)
        val saveBtn = findViewById<Button>(R.id.saveButton)

        // Show local/private IP
        ipText.text = "Phone IP: ${getLocalIpAddress()}"

        // Load saved server URL
        val prefs = getSharedPreferences("app_prefs", MODE_PRIVATE)
        serverIpInput.setText(prefs.getString("server_url", ""))

        // Save server URL
        saveBtn.setOnClickListener {
            val editor = prefs.edit()
            editor.putString("server_url", serverIpInput.text.toString())
            editor.apply()
            finish()
        }
    }

    private fun getLocalIpAddress(): String {
        try {
            val interfaces = java.net.NetworkInterface.getNetworkInterfaces()
            for (intf in interfaces) {
                val addrs = intf.inetAddresses
                for (addr in addrs) {
                    if (!addr.isLoopbackAddress && addr is java.net.Inet4Address) {
                        return addr.hostAddress ?: "Unavailable"
                    }
                }
            }
        } catch (ex: Exception) {
            ex.printStackTrace()
        }
        return "Unavailable"
    }

}

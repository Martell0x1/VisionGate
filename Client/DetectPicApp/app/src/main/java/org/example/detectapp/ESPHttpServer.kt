package org.example.detectapp

import fi.iki.elonen.NanoHTTPD

class ESPHttpServer(port: Int, val listener: (String) -> Unit) : NanoHTTPD(port) {
    override fun serve(session: IHTTPSession?): Response {
        val uri = session?.uri ?: "/"
        return when (uri) {
            "/take_pic" -> {
                listener("take_pic")
                newFixedLengthResponse("📸 Taking picture...")
            }
            else -> newFixedLengthResponse("Unknown endpoint")
        }
    }
}

package com.hjozaty.app.core.logging

import android.util.Log

/** Debug-only logger; never pass tokens, PII, request bodies, or response bodies. */
class DebugLogger : AppLogger { override fun debug(message: String) = Log.d(TAG, message); override fun error(message: String, throwable: Throwable?) = Log.e(TAG, message, throwable); private companion object { const val TAG = "Hjozaty" } }
/** Release logger intentionally emits no logs, preventing accidental data disclosure. */
class ReleaseLogger : AppLogger { override fun debug(message: String) = Unit; override fun error(message: String, throwable: Throwable?) = Unit }

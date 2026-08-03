package com.hjozaty.app.core.logging

/** Logging abstraction. Callers must only provide sanitized operational messages. */
interface AppLogger { fun debug(message: String); fun error(message: String, throwable: Throwable? = null) }

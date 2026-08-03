package com.hjozaty.app.core.logging

import com.hjozaty.app.BuildConfig
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

/** Provides a debug logger only to debug builds and a no-op logger to release builds. */
@Module
@InstallIn(SingletonComponent::class)
object LoggingModule {
    @Provides @Singleton fun provideLogger(): AppLogger = if (BuildConfig.DEBUG) DebugLogger() else ReleaseLogger()
}

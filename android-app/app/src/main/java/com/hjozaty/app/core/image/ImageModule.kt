package com.hjozaty.app.core.image

import android.content.Context
import coil.ImageLoader
import coil.disk.DiskCache
import coil.memory.MemoryCache
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

/** One cached image pipeline for the whole app; feature UIs never create loaders themselves. */
@Module
@InstallIn(SingletonComponent::class)
object ImageModule {
    @Provides
    @Singleton
    fun provideImageLoader(@ApplicationContext context: Context): ImageLoader = ImageLoader.Builder(context)
        .crossfade(true)
        .memoryCache { MemoryCache.Builder(context).maxSizePercent(0.20).build() }
        .diskCache { DiskCache.Builder().directory(context.cacheDir.resolve("hjozaty_images")).maxSizePercent(0.02).build() }
        .build()
}

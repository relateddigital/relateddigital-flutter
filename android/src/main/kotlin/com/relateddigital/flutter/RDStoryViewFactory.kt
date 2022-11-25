package com.relateddigital.flutter

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class RDStoryViewFactory internal constructor(
    @NonNull messenger: BinaryMessenger,
    channel: MethodChannel
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    @NonNull
    private val messenger: BinaryMessenger
    private val channel: MethodChannel

    init {
        this.messenger = messenger
        this.channel = channel
    }

    @Override
    fun create(context: Context?, viewId: Int, args: Object?): PlatformView {
        return RDStoryView(context, viewId, args, channel)
    }
}
package com.relateddigital.flutter

import android.content.Context
import android.view.View
import java.util.Map
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class RelatedDigitalStoryViewFactory internal constructor(
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
        return RelatedDigitalStoryView(context, viewId, args, channel)
    }
}
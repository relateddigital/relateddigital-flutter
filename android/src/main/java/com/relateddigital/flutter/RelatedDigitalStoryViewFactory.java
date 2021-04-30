package com.relateddigital.flutter;

import android.content.Context;
import android.view.View;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class RelatedDigitalStoryViewFactory extends PlatformViewFactory {
    @NonNull
    private final BinaryMessenger messenger;
    private final MethodChannel channel;

    RelatedDigitalStoryViewFactory(@NonNull BinaryMessenger messenger, MethodChannel channel) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
        this.channel = channel;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;
        return new RelatedDigitalStoryView(context, viewId, creationParams, channel);
    }
}
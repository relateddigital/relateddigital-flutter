package com.relateddigital.flutter;

import android.content.Context;
import android.graphics.Color;
import android.os.Handler;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.relateddigital.flutter.R;
import com.visilabs.inApp.bannercarousel.BannerItemClickListener;
import com.visilabs.inApp.bannercarousel.BannerRecyclerView;
import com.visilabs.inApp.bannercarousel.BannerRequestListener;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

import java.util.HashMap;
import java.util.Map;

public class RelatedDigitalBannerView implements PlatformView {

    private final FrameLayout rootView;
    private final BannerRecyclerView bannerRecyclerView;
    private final Context context;

    private final MethodChannel channel;
    private HashMap<String, String> properties = new HashMap<>();
    private int viewId;
    private final Handler handler = new Handler();

    public RelatedDigitalBannerView(Context context, int id, @Nullable Map<String, Object> creationParams, MethodChannel channel) {
        this.channel = channel;
        this.context = context;
        this.viewId = id;
        // LayoutInflater ile layout yükleniyor
        LayoutInflater inflater = LayoutInflater.from(context);
        rootView = new FrameLayout(context);
        View view = inflater.inflate(R.layout.banner_view, rootView, true);
        bannerRecyclerView = view.findViewById(R.id.bannerListView);
        if (creationParams != null) {
            setProperties(creationParams);
        }
        requestBannerCarousel();
    }

    public void setProperties(Map<String, Object> props) {
        if (props != null) {
            this.properties.clear();
            for (Map.Entry<String, Object> entry : props.entrySet()) {
                this.properties.put(entry.getKey(), entry.getValue().toString());
            }
        }
    }

    public void requestBannerCarousel() {
        try {
            BannerItemClickListener clickListener = new BannerItemClickListener() {
                @Override
                public void bannerItemClicked(String bannerLink) {
                    Map<String, String> result = new HashMap<String, String>();
                    result.put("bannerLink", bannerLink);

                    channel.invokeMethod(Constants.M_BANNER_ITEM_CLICK, result);
                }
            };

            bannerRecyclerView.requestBannerCarouselAction(
                    context,
                    properties,
                    new BannerRequestListener() {
                        @Override
                        public void onRequestResult(boolean isAvailable, int height, int width) {

                            Map<String, Object> result = new HashMap<>();
                            result.put("isAvailable", isAvailable);
                            result.put("width", width);
                            result.put("height", height);
                            channel.invokeMethod(Constants.M_BANNER_REQUEST_RESULT, result);

                            handler.post(() -> {
                                FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(
                                        width == 600 ? FrameLayout.LayoutParams.MATCH_PARENT :
                                                (width > 0 ? width : FrameLayout.LayoutParams.MATCH_PARENT),
                                        height > 0 ? height : FrameLayout.LayoutParams.WRAP_CONTENT
                                );

                                bannerRecyclerView.setLayoutParams(params);
                                bannerRecyclerView.requestLayout();
                            });
                        }
                    },
                    clickListener
            );

            if (bannerRecyclerView.getAdapter() != null) {
                handler.post(() -> {
                    bannerRecyclerView.postDelayed(() -> bannerRecyclerView.smoothScrollToPosition(0), 0);
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public View getView() {
        return rootView;
    }

    @Override
    public void dispose() {

    }
}
package com.relateddigital.flutter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

import com.visilabs.story.StoryRequestListener;
import com.visilabs.story.VisilabsRecyclerView;
import com.visilabs.story.model.StoryItemClickListener;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class RelatedDigitalStoryView implements PlatformView {
    private static final int CIRCLE_OR_SQUARE_HEIGHT_DP = 120;
    private static final int RECTANGLE_EXTRA_DP = 48;

    private final VisilabsRecyclerView recyclerView;
    private final MethodChannel channel;
    private boolean heightReported = false;

    RelatedDigitalStoryView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams, MethodChannel channel) {
        this.channel = channel;

        String actionId = null;
        if (creationParams != null && creationParams.get("actionId") != null) {
            actionId = creationParams.get("actionId").toString();
        }

        recyclerView = new VisilabsRecyclerView(context);
        recyclerView.setHasFixedSize(false);
        recyclerView.setClipChildren(false);
        recyclerView.setClipToPadding(false);
        if (creationParams != null && creationParams.get("backgroundColor") instanceof Number) {
            recyclerView.setBackgroundColor(((Number) creationParams.get("backgroundColor")).intValue());
        }

        recyclerView.addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
            @Override
            public void onLayoutChange(View v, int left, int top, int right, int bottom,
                                       int oldLeft, int oldTop, int oldRight, int oldBottom) {
                if ((bottom - top) != (oldBottom - oldTop) && recyclerView.getAdapter() != null) {
                    recyclerView.post(new Runnable() {
                        @Override
                        public void run() {
                            if (recyclerView.getAdapter() != null) {
                                recyclerView.getAdapter().notifyDataSetChanged();
                            }
                        }
                    });
                }
            }
        });

        recyclerView.addOnChildAttachStateChangeListener(new RecyclerView.OnChildAttachStateChangeListener() {
            @Override
            public void onChildViewAttachedToWindow(@NonNull View view) {
                reportHeight(view);
            }

            @Override
            public void onChildViewDetachedFromWindow(@NonNull View view) {
            }
        });

        getStories(context, actionId);
    }

    @Override
    public View getView() {
        return recyclerView;
    }

    @Override
    public void dispose() {
    }

    private void getStories(Context context, String actionId) {
        try {
            StoryItemClickListener storyItemClickListener = new StoryItemClickListener() {
                @Override
                public void storyItemClicked(String storyLink) {
                    Map<String, String> result = new HashMap<String, String>();
                    result.put("storyLink", storyLink);
                    channel.invokeMethod(Constants.M_STORY_ITEM_CLICK, result);
                }
            };

            StoryRequestListener requestListener = new StoryRequestListener() {
                @Override
                public void onRequestResult(boolean isAvailable) {
                    recyclerView.post(new Runnable() {
                        @Override
                        public void run() {
                            if (recyclerView.getChildCount() > 0) {
                                reportHeight(recyclerView.getChildAt(0));
                            }
                        }
                    });
                }
            };

            if (actionId != null) {
                recyclerView.setStoryActionIdWithRequestCallback(context, actionId, storyItemClickListener, requestListener);
            } else {
                recyclerView.setStoryActionWithRequestCallback(context, storyItemClickListener, requestListener);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void reportHeight(final View child) {
        if (heightReported || child == null) {
            return;
        }
        recyclerView.post(new Runnable() {
            @Override
            public void run() {
                if (heightReported) {
                    return;
                }
                int imageHeightPx = findMaxImageHeightPx(child);
                if (imageHeightPx <= 0) {
                    return;
                }
                heightReported = true;
                float density = recyclerView.getResources().getDisplayMetrics().density;
                int imageDp = Math.round(imageHeightPx / density);
                // Native rectangle image is 240dp; circle/square image is 72dp.
                // Title + 8dp item margins need extra room either way.
                int heightDp = imageDp >= 200
                        ? imageDp + RECTANGLE_EXTRA_DP
                        : CIRCLE_OR_SQUARE_HEIGHT_DP;
                Map<String, Object> result = new HashMap<String, Object>();
                result.put("height", heightDp);
                channel.invokeMethod(Constants.M_STORY_REQUEST_RESULT, result);
            }
        });
    }

    private int findMaxImageHeightPx(View view) {
        int max = 0;
        if (view instanceof ImageView) {
            ViewGroup.LayoutParams lp = view.getLayoutParams();
            if (lp != null && lp.height > 0) {
                max = lp.height;
            }
        }
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) {
                max = Math.max(max, findMaxImageHeightPx(group.getChildAt(i)));
            }
        }
        return max;
    }
}

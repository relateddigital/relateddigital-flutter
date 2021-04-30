package com.relateddigital.flutter;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.visilabs.story.VisilabsRecyclerView;
import com.visilabs.story.model.StoryItemClickListener;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class RelatedDigitalStoryView implements PlatformView {
    private final VisilabsRecyclerView recyclerView;
    private final MethodChannel channel;

    RelatedDigitalStoryView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams, MethodChannel channel) {
        this.channel = channel;

        String actionId = null;
        if(creationParams.get("actionId") != null) {
            actionId = creationParams.get("actionId").toString();
        }

        recyclerView = new VisilabsRecyclerView(context);
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
        StoryItemClickListener storyItemClickListener = new StoryItemClickListener() {
            @Override
            public void storyItemClicked(String storyLink) {
                Map<String, String> result = new HashMap<String, String>();
                result.put("storyLink", storyLink);

                channel.invokeMethod(Constants.M_STORY_ITEM_CLICK, result);
            }
        };

        if(actionId != null) {
            recyclerView.setStoryActionId(context, actionId, storyItemClickListener);
        }
        else {
            recyclerView.setStoryAction(context, storyItemClickListener);
        }
    }
}
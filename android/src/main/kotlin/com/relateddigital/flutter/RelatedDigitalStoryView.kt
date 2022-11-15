package com.relateddigital.flutter

import android.content.Context
import android.graphics.Color
import android.view.View
import android.widget.TextView
import java.util.HashMap
import java.util.Map
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView


import com.relateddigital.relateddigital_android.inapp.story.StoryRecyclerView
import com.relateddigital.relateddigital_android.inapp.story.StoryItemClickListener




class RelatedDigitalStoryView internal constructor(
    @NonNull context: Context,
    id: Int,
    @Nullable creationParams: Map<String?, Object?>,
    channel: MethodChannel
) : PlatformView {
    private val recyclerView: StoryRecyclerView
    private val channel: MethodChannel

    init {
        this.channel = channel
        var actionId: String? = null
        if (creationParams["actionId"] != null) {
            actionId = creationParams["actionId"].toString()
        }
        recyclerView = StoryRecyclerView(context)
        getStories(context, actionId)
    }

    @get:Override
    val view: View
        get() = recyclerView

    @Override
    fun dispose() {
    }

    private fun getStories(context: Context, actionId: String?) {
        try {
            val storyItemClickListener: StoryItemClickListener = object : StoryItemClickListener() {
                @Override
                fun storyItemClicked(storyLink: String?) {
                    val result: Map<String, String> = HashMap<String, String>()
                    result.put("storyLink", storyLink)
                    channel.invokeMethod(Constants.M_STORY_ITEM_CLICK, result)
                }
            }
            if (actionId != null) {
                recyclerView.setStoryActionId(context, actionId, storyItemClickListener)
            } else {
                recyclerView.setStoryAction(context, storyItemClickListener)
            }
        } catch (ex: Exception) {
            ex.printStackTrace()
        }
    }
}
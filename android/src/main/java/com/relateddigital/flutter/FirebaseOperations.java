package com.relateddigital.flutter;
​
import android.content.Context;
​
import androidx.annotation.NonNull;
​
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.messaging.FirebaseMessaging;
import java.util.HashMap;
import java.util.Map;
​
import euromsg.com.euromobileandroid.EuroMobileManager;
import io.flutter.plugin.common.MethodChannel;
​
public class FirebaseOperations {
    private final Context mContext;
    private final MethodChannel mChannel;
​
    public FirebaseOperations(Context context, MethodChannel channel) {
        mContext = context;
        mChannel = channel;
    }
​
    public void setExistingFirebaseTokenToEuroMessage() {
​
​
        FirebaseMessaging.getInstance().getToken()
                .addOnCompleteListener(new OnCompleteListener<String>() {
                    @Override
                    public void onComplete(@NonNull Task<String> task) {
                        if (!task.isSuccessful()) {
                            return;
                        }
                        String token = task.getResult();
                        EuroMobileManager.getInstance().subscribe(token, mContext);
​
                        Map <String, Object> result = new HashMap<>();
                        result.put("deviceToken", token);
                        result.put("playServiceEnabled", EuroMobileManager.checkPlayService(mContext));
​
                        mChannel.invokeMethod(Constants.M_TOKEN_RETRIEVED, result);
                    }
                });
    }
}
package li.haomin.flutter_aliplayer.listener;

import android.util.Log;

import com.aliyun.player.IPlayer;
import com.aliyun.player.bean.ErrorInfo;
import com.aliyun.player.bean.InfoBean;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class EventListener implements IPlayer.OnPreparedListener, IPlayer.OnCompletionListener, IPlayer.OnInfoListener,
        IPlayer.OnErrorListener, IPlayer.OnStateChangedListener, IPlayer.OnLoadingStatusListener {

    private static final String TAG = "flutter_aliplayer";

    private MethodChannel methodChannel;

    public EventListener(MethodChannel methodChannel) {
        this.methodChannel = methodChannel;
    }

    @Override
    public void onPrepared() {
        Log.d(TAG, "准备播放");
        Map<String, Object> args = new HashMap<>();
        args.put("event", "onPrepared");
        methodChannel.invokeMethod("eventListener", args);
    }

    @Override
    public void onCompletion() {
        Log.d(TAG, "播放完成");
        Map<String, Object> args = new HashMap<>();
        args.put("event", "onCompletion");
        methodChannel.invokeMethod("eventListener", args);
    }

    @Override
    public void onError(ErrorInfo error) {
        Log.e(TAG, String.format("播放出错：code: %s, msg: %s, ext: %s", error.getCode(), error.getMsg(), error.getExtra()));
        Map<String, Object> args = new HashMap<>();
        args.put("event", "onError");
        args.put("code", error.getCode().name());
        args.put("msg", error.getMsg());
        args.put("extra", error.getExtra());
        methodChannel.invokeMethod("eventListener", args);
    }

    @Override
    public void onStateChanged(int state) {
        Log.d(TAG, "播放状态改变 -> " + state);
        Map<String, Object> args = new HashMap<>();
        args.put("event", "onStateChanged");
        args.put("state", state);
        methodChannel.invokeMethod("eventListener", args);
    }

    @Override
    public void onInfo(InfoBean info) {
        Map<String, Object> args = new HashMap<>();
        switch (info.getCode()) {
            case BufferedPosition:
                Log.d(TAG, String.format("其他信息：【%s - %s】", info.getCode(), info.getExtraValue()));
                args.put("event", "onBufferedPosition");
                args.put("position", info.getExtraValue());
                methodChannel.invokeMethod("eventListener", args);
                break;
            case CurrentPosition:
                Log.d(TAG, String.format("其他信息：【%s - %s】", info.getCode(), info.getExtraValue()));
                args.put("event", "onCurrentPosition");
                args.put("position", info.getExtraValue());
                methodChannel.invokeMethod("eventListener", args);
                break;
            default:
                Log.d(TAG, String.format("其他信息：【%s - %s】", info.getCode(), info.getExtraMsg()));
                args.put("event", "onInfo");
                args.put("code", info.getCode().name());
                args.put("msg", info.getExtraMsg());
                args.put("value", info.getExtraValue());
                methodChannel.invokeMethod("eventListener", args);
        }
    }

    @Override
    public void onLoadingBegin() {
        Log.d(TAG, "缓存开始");
        Map<String, Object> args = new HashMap<>();
        args.put("event", "onLoadingBegin");
        methodChannel.invokeMethod("eventListener", args);
    }

    @Override
    public void onLoadingProgress(int percent, float kbps) {
        Log.d(TAG, String.format("缓冲进度：【%d - %f】", percent, kbps));
        Map<String, Object> args = new HashMap<>();
        args.put("event", "onLoadingProgress");
        args.put("percent", percent);
        args.put("kbps", kbps);
        methodChannel.invokeMethod("eventListener", args);
    }

    @Override
    public void onLoadingEnd() {
        Log.d(TAG, "缓存结束");
        Map<String, Object> args = new HashMap<>();
        args.put("event", "onLoadingEnd");
        methodChannel.invokeMethod("eventListener", args);
    }
}

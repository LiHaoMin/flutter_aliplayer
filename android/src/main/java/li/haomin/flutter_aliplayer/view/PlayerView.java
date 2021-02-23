package li.haomin.flutter_aliplayer.view;

import android.content.Context;
import android.view.SurfaceView;
import android.view.View;

import com.aliyun.player.AliPlayer;
import com.aliyun.player.AliPlayerFactory;
import com.aliyun.player.source.VidAuth;
import com.aliyun.player.source.UrlSource;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import li.haomin.flutter_aliplayer.listener.EventListener;

public class PlayerView extends PlatformViewFactory implements PlatformView, MethodChannel.MethodCallHandler {
    public static final String VIEW_NAME = "li.haomin.aliplayer.view/player";

    private Context context;
    private BinaryMessenger messenger;

    private MethodChannel methodChannel;
    private EventListener eventListener;

    private SurfaceView surfaceView;
    private AliPlayer aliPlayer;

    public PlayerView(Context context, BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.context = context;
        this.messenger = messenger;
    }

    private PlayerView(Context context) {
        super(StandardMessageCodec.INSTANCE);
        this.context = context;
        surfaceView = new SurfaceView(this.context);
    }

    @Override
    public View getView() {
        return surfaceView;
    }

    @Override
    public void dispose() {

    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        PlayerView playerView = new PlayerView(context);
        // 绑定方法监听器
        methodChannel = new MethodChannel(messenger, VIEW_NAME + "_" + viewId);
        methodChannel.setMethodCallHandler(playerView);
        playerView.setListener(new EventListener(methodChannel));
        return playerView;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "init":
                init();
                break;
            case "setDataSource":
                VidAuth vidAuth = new VidAuth();
                vidAuth.setVid(call.argument("vid").toString());
                vidAuth.setPlayAuth(call.argument("auth").toString());
                aliPlayer.setDataSource(vidAuth);
                aliPlayer.setAutoPlay(true);
                aliPlayer.prepare();
                break;
            case "setUrlDataSource":
                UrlSource urlSource = new UrlSource();
                urlSource.setUri(call.argument("playurl").toString());
                aliPlayer.setDataSource(urlSource);
                aliPlayer.setAutoPlay(true);
                aliPlayer.prepare();
                break;
            case "start":
                aliPlayer.start();
                break;
            case "stop":
                aliPlayer.stop();
                break;
            case "pause":
                aliPlayer.pause();
                break;
            case "seekTo":
                long seek = Long.valueOf(call.argument("seek").toString());
                aliPlayer.seekTo(seek);
                break;
            case "release":
                if (aliPlayer != null) {
                    aliPlayer.release();
                    aliPlayer = null;
                }
                break;
            case "getDuration":
                result.success(aliPlayer.getDuration());
                break;
            case "getVideoWidth":
                result.success(aliPlayer.getVideoWidth());
                break;
            case "getVideoHeight":
                result.success(aliPlayer.getVideoHeight());
                break;
            case "setVolume":
                float volume = Float.valueOf(call.argument("volume").toString());
                aliPlayer.setVolume(volume);
                break;
            case "getVolume":
                result.success(aliPlayer.getVolume());
                break;
            case "setMute":
                boolean flag = call.argument("flag");
                aliPlayer.setMute(flag);
                break;
            case "isMute":
                result.success(aliPlayer.isMute());
                break;
            default:
                result.notImplemented();
        }
    }

    private void init() {
        if (aliPlayer != null) {
            return;
        }
        aliPlayer = AliPlayerFactory.createAliPlayer(context);
        aliPlayer.setOnPreparedListener(eventListener);
        aliPlayer.setOnCompletionListener(eventListener);
        aliPlayer.setOnErrorListener(eventListener);
        aliPlayer.setOnStateChangedListener(eventListener);
        aliPlayer.setOnInfoListener(eventListener);
        aliPlayer.setOnLoadingStatusListener(eventListener);
        aliPlayer.setDisplay(surfaceView.getHolder());
        aliPlayer.setAutoPlay(true);
    }

    private void setListener(EventListener eventListener) {
        this.eventListener = eventListener;
    }
}

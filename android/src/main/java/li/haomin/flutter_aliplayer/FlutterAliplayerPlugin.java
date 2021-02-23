package li.haomin.flutter_aliplayer;

import android.app.Application;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import li.haomin.flutter_aliplayer.view.PlayerView;

/** FlutterAliplayerPlugin */
public class FlutterAliplayerPlugin implements FlutterPlugin, MethodCallHandler {
  private static final String CHANNEL_NAME = "flutter_aliplayer";

  private MethodChannel channel;
  private Application mApplication;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), CHANNEL_NAME);
    channel.setMethodCallHandler(this);
    mApplication = (Application) flutterPluginBinding.getApplicationContext();
    flutterPluginBinding.getPlatformViewRegistry().registerViewFactory(PlayerView.VIEW_NAME, new PlayerView(mApplication, flutterPluginBinding.getBinaryMessenger()));
  }

  public MethodCallHandler initPlugin(MethodChannel methodChannel, Registrar registrar) {
    channel = methodChannel;
    mApplication = (Application) registrar.context().getApplicationContext();
    registrar.platformViewRegistry().registerViewFactory(PlayerView.VIEW_NAME, new PlayerView(mApplication, registrar.messenger()));
    return this;
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME);
    channel.setMethodCallHandler(new FlutterAliplayerPlugin().initPlugin(channel, registrar));
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      default:
        result.notImplemented();
    }
  }
}

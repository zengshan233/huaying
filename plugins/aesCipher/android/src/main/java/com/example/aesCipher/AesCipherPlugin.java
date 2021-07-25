package com.example.aesCipher;

import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;


/** AesCipherPlugin */
public class AesCipherPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "aesCipher");
    channel.setMethodCallHandler(this);
  }


  @RequiresApi(api = Build.VERSION_CODES.O)
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if(call.method.equals("encrypt")){
      String message = (String) call.argument("data");
      String encrptKey = (String) call.argument("key");
      byte[] data = message.getBytes(StandardCharsets.UTF_8);
      byte[] key = new byte[0];
      try {
        key =encrptKey.getBytes("UTF-8");
      } catch (UnsupportedEncodingException e) {
        e.printStackTrace();
      }
      byte[] encrypted = new byte[0];
      try {
        encrypted = AES_ECB_Cipher.encrypt(key,data);
      } catch (NoSuchAlgorithmException e) {
        e.printStackTrace();
      } catch (NoSuchPaddingException e) {
        e.printStackTrace();
      } catch (InvalidKeyException e) {
        e.printStackTrace();
      } catch (IllegalBlockSizeException e) {
        e.printStackTrace();
      } catch (BadPaddingException e) {
        e.printStackTrace();
      }
      String encrptedData = Base64.getEncoder().encodeToString(encrypted);
      result.success(encrptedData);
    }else if(call.method.equals("decrypt")){
      String message = (String) call.argument("data");
      String decryptKey = (String) call.argument("key");
      byte[] decrptedData = Base64.getDecoder().decode(message);
      byte[] key = new byte[0];
      try {
        key =decryptKey.getBytes("UTF-8");
      } catch (UnsupportedEncodingException e) {
        e.printStackTrace();
      }
      byte[] decrypted = new byte[0];
      try {
        decrypted = AES_ECB_Cipher.decrypt(key,decrptedData);
      } catch (NoSuchAlgorithmException e) {
        e.printStackTrace();
      } catch (NoSuchPaddingException e) {
        e.printStackTrace();
      } catch (InvalidKeyException e) {
        e.printStackTrace();
      } catch (IllegalBlockSizeException e) {
        e.printStackTrace();
      } catch (BadPaddingException e) {
        e.printStackTrace();
      }
      String resultData = null;
      try {
         resultData =new String(decrypted, "UTF-8");
      } catch (UnsupportedEncodingException e) {
        e.printStackTrace();
      }
      result.success(resultData);
    }else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}

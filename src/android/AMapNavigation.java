package com.kit.cordova.amapnavigation;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.util.Log;
import android.widget.Toast;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * This class echoes a string called from JavaScript.
 */
public class AMapNavigation extends CordovaPlugin {
    private CallbackContext callbackContext;
    private static AMapNavigation mapNavigation = null;
    public static CordovaWebView cordovaWebView = null;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        cordovaWebView = webView;
        if (action.equals("navigation")) {
            Log.i("result","Navigation");
            //String message = args.getString(0);
//            mapNavigation = this;
//            this.callbackContext = callbackContext;
//            Intent intent = new Intent();
//            intent.setClass(this.cordova.getActivity().getApplicationContext(), NavigationActivity.class);
//            Log.i("result",args.getString(0));
//            Log.i("result",args.getString(1));
//            Log.i("result",args.getString(2));
//            Log.i("result",args.getString(3));
//            intent.putExtra("NaviStartLng", args.getString(0));
//            intent.putExtra("NaviStartLat", args.getString(1));
//            intent.putExtra("NaviEndLng", args.getString(2));
//            intent.putExtra("NaviEndLat", args.getString(3));
//            intent.putExtra("NavType", args.getString(4));
//            Log.i("result","cordova");
//            this.cordova.startActivityForResult((CordovaPlugin) this, intent, 100);
            if(isAvilible(this.cordova.getActivity(),"com.autonavi.minimap")){
                Intent intent = new Intent();
                intent.setAction(Intent.ACTION_VIEW);
                intent.addCategory(Intent.CATEGORY_DEFAULT);
                String urlStr = "androidamap://navi?sourceApplication=appname&lat="+args.getString(3) +
                        "&lon="+args.getString(2)+"&dev=1&style=2";
                Uri uri = Uri.parse(urlStr);
                intent.setData(uri);
                //启动该页面即可
                this.cordova.getActivity().startActivity(intent);
            }else {
                Toast.makeText(this.cordova.getActivity(),"暂未安装高德地图",Toast.LENGTH_SHORT).show();
            }

            return true;
        }
        return false;
    }

    @SuppressLint("LongLogTag")
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        if(requestCode == 100){
            JSONObject json = new JSONObject();
            try{
                if(resultCode == Activity.RESULT_CANCELED){
                    json.put("status", -1);
                    PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, json);
                    callbackContext.sendPluginResult(pluginResult);
                }else{
                    json.put("status", 0);
                    PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, json);
                    callbackContext.sendPluginResult(pluginResult);
                }
            }catch (JSONException ex){
                Log.e("AMapNavigation.onActivityResult", ex.getMessage());
            }
        }
    }

    public static AMapNavigation getInstance(){
        return mapNavigation;
    }
    /**
     * 检查手机上是否安装了指定的软件
     * @param context
     * @param packageName：应用包名
     * @return
     */
    private boolean isAvilible(Context context, String packageName){
        //获取packagemanager
        final PackageManager packageManager = context.getPackageManager();
        //获取所有已安装程序的包信息
        List<PackageInfo> packageInfos = packageManager.getInstalledPackages(0);
        //用于存储所有已安装程序的包名
        List<String> packageNames = new ArrayList<String>();
        //从pinfo中将包名字逐一取出，压入pName list中
        if(packageInfos != null){
            for(int i = 0; i < packageInfos.size(); i++){
                String packName = packageInfos.get(i).packageName;
                packageNames.add(packName);
            }
        }
        //判断packageNames中是否有目标程序的包名，有TRUE，没有FALSE
        return packageNames.contains(packageName);
    }
}

package com.sim.traveltool;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.os.Environment;

import androidx.multidex.MultiDex;

import com.sim.baselibrary.utils.CrashHandler;
import com.sim.baselibrary.utils.LogUtil;
import com.sim.traveltool.internet.APIFactory;
import com.tencent.bugly.Bugly;
import com.tencent.bugly.beta.Beta;

import cn.bmob.v3.Bmob;
import cn.jpush.android.api.JPushInterface;

/**
 * @author Sim --- Application
 */
public class Application extends android.app.Application {

    private static Context context;
    private static Boolean isDebug = null;

    @Override
    public void onCreate() {
        super.onCreate();
        context = getApplicationContext();
        isDebug = context.getApplicationInfo() != null &&
                (context.getApplicationInfo().flags & ApplicationInfo.FLAG_DEBUGGABLE) != 0;
        LogUtil.d(getClass(), isDebug ? "DeBug模式" : "Release版本");


        CrashHandler.getInstance().init(context, Environment.getExternalStorageDirectory() + "/Sim/log");//自定义奔溃处理类初始化

        Bugly.init(this, AppHelper.Bugly_APPID, isDebug);//Bugly初始化
//        Beta.autoInit = true;//启动自动初始化升级模块
//        Beta.autoCheckUpgrade = true;//自动检查升级
//        Beta.upgradeCheckPeriod = 1000 * 60;//设置升级检查周期为60s
//        Beta.initDelay = 1000 * 5;//设置启动延迟为5s

        JPushInterface.setDebugMode(isDebug);//JPush设置DebugMode
        JPushInterface.init(this);//JPush初始化

        Bmob.initialize(this, AppHelper.Bmob_ApplicationID);//Bmob初始化

        APIFactory.getInstance().init(this);
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(base);//you must install multiDex whatever tinker is installed!
        Beta.installTinker();//安装tinker
    }

    public static Context getMyApplicationContext() {
        return context;
    }

    public static Boolean getIsDebug() {
        return isDebug;
    }

}

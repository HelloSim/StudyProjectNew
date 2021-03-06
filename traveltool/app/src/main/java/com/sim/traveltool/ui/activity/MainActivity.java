package com.sim.traveltool.ui.activity;

import android.Manifest;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.RadioButton;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.drawerlayout.widget.DrawerLayout;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.sim.baselibrary.base.BaseActivity;
import com.sim.baselibrary.bean.EventMessage;
import com.sim.baselibrary.utils.LogUtil;
import com.sim.baselibrary.utils.SPUtil;
import com.sim.baselibrary.utils.ToastUtil;
import com.sim.traveltool.AppHelper;
import com.sim.traveltool.R;
import com.sim.traveltool.bean.db.User;
import com.sim.traveltool.ui.fragment.BusFragment;
import com.sim.traveltool.ui.fragment.RecordFragment;
import com.sim.traveltool.ui.fragment.WangyiFragment;
import com.tencent.bugly.beta.Beta;
import com.tencent.bugly.beta.UpgradeInfo;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

import cn.bmob.v3.BmobUser;
import cn.bmob.v3.exception.BmobException;
import cn.bmob.v3.listener.FetchUserInfoListener;

/**
 * @author Sim --- MainActivity
 */
public class MainActivity extends BaseActivity {

    private DrawerLayout drawerLayout;

    private RadioButton rbBottomBarBus, rbBottomBarWangyi, rbBottomBarRecord;

    private RelativeLayout rlUser, rlUserCollect, rlUpdateVersion, rlUserSetting;
    private TextView tvUserName;

    private BusFragment busFragment;
    private WangyiFragment wangyiFragment;
    private RecordFragment recordFragment;

    private FragmentManager mFragmentManager;
    private FragmentTransaction mFragmentTransaction;

    private Handler handler;
    private int count = 0;

    private User user;

    @Override
    protected void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
    }

    @Override
    protected int getLayoutRes() {
        return R.layout.activity_main;
    }

    @Override
    protected void bindViews(Bundle savedInstanceState) {
        drawerLayout = findViewById(R.id.dl_drawer);
        rbBottomBarBus = findViewById(R.id.rb_bottom_bar_bus);
        rbBottomBarWangyi = findViewById(R.id.rb_bottom_bar_wangyi);
        rbBottomBarRecord = findViewById(R.id.rb_bottom_bar_record);
        rlUser = findViewById(R.id.rl_user);
        rlUserCollect = findViewById(R.id.rl_user_collect);
        rlUpdateVersion = findViewById(R.id.rl_update_version);
        rlUserSetting = findViewById(R.id.rl_user_setting);
        tvUserName = findViewById(R.id.tv_user_name);
        setViewClick(rlUser, rlUserCollect, rlUpdateVersion, rlUserSetting, rbBottomBarBus, rbBottomBarWangyi, rbBottomBarRecord);
    }

    @Override
    protected void initData() {
        requestPermission(new String[]{Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE}, 0x001);
        EventBus.getDefault().register(this);

        if (SPUtil.contains(this, AppHelper.userSpName, AppHelper.userSpStateKey) &&
                ((boolean) SPUtil.get(this, AppHelper.userSpName, AppHelper.userSpStateKey, false)) && BmobUser.isLogin()) {
            user = BmobUser.getCurrentUser(User.class);
        }

        handler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                super.handleMessage(msg);
                count = 0;
            }
        };
    }

    @Override
    protected void initView() {
        rbBottomBarWangyi.performClick();
        if (user != null) {
            tvUserName.setText(user.getUsername());
        } else {
            tvUserName.setText("????????????");
        }
    }

    @Override
    public void onMultiClick(View view) {
        if (view == rlUser) {
            drawerLayout.closeDrawers();
            if (user != null) {
                startActivity(new Intent(this, UserInfoActivity.class));
            } else {
                startActivity(new Intent(this, UserLogInActivity.class));
            }
        } else if (view == rlUserCollect) {
            if (user != null) {
                drawerLayout.closeDrawers();
                startActivity(new Intent(this, NewsCollectActivity.class));
            } else {
                ToastUtil.toast(this, "?????????");
            }
        } else if (view == rlUpdateVersion) {
//            Beta.checkAppUpgrade();
//            loadUpgradeInfo();
        } else if (view == rlUserSetting) {
            clickMark();
        } else if (view == rbBottomBarBus) {
            showFragment(1);
        } else if (view == rbBottomBarWangyi) {
            showFragment(2);
        } else if (view == rbBottomBarRecord) {
            showFragment(3);
        } else {
            super.onMultiClick(view);
        }
    }

    private void loadUpgradeInfo() {
        UpgradeInfo upgradeInfo = Beta.getUpgradeInfo();
        if (upgradeInfo == null) {
            return;
        }
        LogUtil.d(getClass(), "????????????: " + upgradeInfo.versionName);
    }

    /**
     * ???????????????fragment??????????????????fragment
     *
     * @param type 1:??????fragment     2?????????fragment    3?????????fragment
     */
    private void showFragment(int type) {
        mFragmentManager = getSupportFragmentManager();
        mFragmentTransaction = mFragmentManager.beginTransaction();
        if (busFragment != null) {
            mFragmentTransaction.hide(busFragment);
        }
        if (wangyiFragment != null) {
            mFragmentTransaction.hide(wangyiFragment);
        }
        if (recordFragment != null) {
            mFragmentTransaction.hide(recordFragment);
        }
        switch (type) {
            case 1:
                if (busFragment == null) {
                    busFragment = new BusFragment();
                    mFragmentTransaction.add(R.id.frameLayout, busFragment);
                } else {
                    mFragmentTransaction.show(busFragment);
                }
                break;
            case 2:
                if (wangyiFragment == null) {
                    wangyiFragment = new WangyiFragment();
                    mFragmentTransaction.add(R.id.frameLayout, wangyiFragment);
                } else {
                    mFragmentTransaction.show(wangyiFragment);
                }
                break;
            case 3:
                if (recordFragment == null) {
                    recordFragment = new RecordFragment();
                    mFragmentTransaction.add(R.id.frameLayout, recordFragment);
                } else {
                    mFragmentTransaction.show(recordFragment);
                }
                break;
        }
        mFragmentTransaction.commit();
    }

    /**
     * ???6??????????????????????????????????????????1s???
     */
    private void clickMark() {
        if (count != 5) {
            handler.removeMessages(1001);
            count++;
            handler.sendEmptyMessageDelayed(1001, 1000);
        } else {
            startActivity(new Intent(this, HideActivity.class));
            count = 0;
        }
    }

    /**
     * ?????????????????????JSON??????????????????????????????
     */
    private void fetchUserJsonInfo() {
        BmobUser.fetchUserJsonInfo(new FetchUserInfoListener<String>() {
            @Override
            public void done(String json, BmobException e) {
                if (e == null) {
                    LogUtil.e(getClass(), "????????????????????????????????????");
                } else {
                    LogUtil.e(getClass(), "????????????????????????????????????---code:" + e.getErrorCode() + ";message:" + e.getMessage());
                }
            }
        });
    }

    /**
     * ??????????????????
     *
     * @param eventMessage
     */
    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onMessageEvent(EventMessage eventMessage) {
        if (eventMessage.type == AppHelper.USER_IsLogIn) {
            user = BmobUser.getCurrentUser(User.class);
            User.fetchUserInfo();
            tvUserName.setText(user.getUsername());
        } else if (eventMessage.type == AppHelper.USER_noLogIn) {
            user = null;
            tvUserName.setText("????????????");
        }
    }

    /**
     * ?????????????????????
     */
    private long exitTime;

    @Override
    public void onBackPressed() {
        if ((System.currentTimeMillis() - exitTime) > 2000) {
            Toast.makeText(getApplicationContext(), "???????????????????????????", Toast.LENGTH_SHORT).show();
            exitTime = System.currentTimeMillis();
        } else {
            finish();
            // ?????????????????????
            try {
                System.exit(0);
            } catch (Exception e) {
                System.exit(1);
            }
        }
    }

}

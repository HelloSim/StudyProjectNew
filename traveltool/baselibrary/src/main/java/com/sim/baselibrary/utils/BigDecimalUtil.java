package com.sim.baselibrary.utils;

import java.math.BigDecimal;

/**
 * @author Sim --- 提供精确的浮点数运算(包括加、减、乘、除、四舍五入)工具类
 */
public class BigDecimalUtil {
    // 除法运算默认精度
    private static final int DEF_DIV_SCALE = 4;
    // 格式化默认精度
    private static final int DEF_SCALE = 2;

    private BigDecimalUtil() {
    }

    /**
     * 精确加法
     */
    public static double add(double value1, double value2) {
        BigDecimal b1 = BigDecimal.valueOf(value1);
        BigDecimal b2 = BigDecimal.valueOf(value2);
        return b1.add(b2).doubleValue();
    }

    /**
     * 精确加法
     */
    public static double add(String value1, String value2) {
        BigDecimal b1 = new BigDecimal(value1);
        BigDecimal b2 = new BigDecimal(value2);
        return b1.add(b2).doubleValue();
    }

    /**
     * 精确减法
     */
    public static double sub(double value1, double value2) {
        BigDecimal b1 = BigDecimal.valueOf(value1);
        BigDecimal b2 = BigDecimal.valueOf(value2);
        return b1.subtract(b2).doubleValue();
    }

    /**
     * 精确减法
     */
    public static double sub(String value1, String value2) {
        BigDecimal b1 = new BigDecimal(value1);
        BigDecimal b2 = new BigDecimal(value2);
        return b1.subtract(b2).doubleValue();
    }

    /**
     * 精确乘法
     */
    public static double mul(double value1, double value2) {
        BigDecimal b1 = BigDecimal.valueOf(value1);
        BigDecimal b2 = BigDecimal.valueOf(value2);
        return b1.multiply(b2).doubleValue();
    }

    /**
     * 精确乘法
     */
    public static double mul(String value1, String value2) {
        BigDecimal b1 = new BigDecimal(value1);
        BigDecimal b2 = new BigDecimal(value2);
        return b1.multiply(b2).doubleValue();
    }

    /**
     * 乘法运算
     *
     * @param b1
     * @param b2
     * @param scale
     * @param <T>
     * @return
     */
    public static <T extends Number> BigDecimal safeMultiply(Double b1, Double b2, int scale) {
        if (null == b1 || null == b2) {
            return BigDecimal.ZERO;
        }
        return BigDecimal.valueOf(b1).multiply(BigDecimal.valueOf(b2)).setScale(scale, BigDecimal.ROUND_DOWN);
    }

    /**
     * 精确除法 使用默认精度
     */
    public static double div(double value1, double value2) {
        return div(value1, value2, DEF_DIV_SCALE);
    }

    /**
     * 精确除法 使用默认精度
     */
    public static double div(String value1, String value2) {
        return div(value1, value2, DEF_DIV_SCALE);
    }

    /**
     * 精确除法
     *
     * @param scale 精度
     */
    public static double div(double value1, double value2, int scale) {
        if (scale < 0) {
            scale = 0;
        }
        BigDecimal b1 = BigDecimal.valueOf(value1);
        BigDecimal b2 = BigDecimal.valueOf(value2);
        //程序操作异常，分母为0的情况，直接返回0
        if (b2.doubleValue() == 0) {
            return 0;
        }
        // return b1.divide(b2, scale).doubleValue();
        return b1.divide(b2, scale, BigDecimal.ROUND_HALF_UP).doubleValue();
    }

    /**
     * 精确除法
     *
     * @param scale 精度
     */
    public static double div(String value1, String value2, int scale) {
        if (scale < 0) {
            scale = 0;
        }
        BigDecimal b1 = new BigDecimal(value1);
        BigDecimal b2 = new BigDecimal(value2);
        //程序操作异常，分母为0的情况，直接返回0
        if (b2.doubleValue() == 0) {
            return 0;
        }
        // return b1.divide(b2, scale).doubleValue();
        return b1.divide(b2, scale, BigDecimal.ROUND_HALF_UP).doubleValue();
    }

    /**
     * 进位除法
     */
    public static double divcarry(double value1, double value2) {
        BigDecimal b1 = new BigDecimal(value1);
        BigDecimal b2 = new BigDecimal(value2);
        //程序操作异常，分母为0的情况，直接返回0
        if (b2.doubleValue() == 0) {
            return 0;
        }
        // return b1.divide(b2, scale).doubleValue();
        return b1.divide(b2, BigDecimal.ROUND_UP).doubleValue();
    }


    /**
     * 四舍五入
     *
     * @param scale 小数点后保留几位
     */
    public static double round(double v, int scale) throws IllegalAccessException {
        return div(v, 1, scale);
    }

    /**
     * 四舍五入
     *
     * @param scale 小数点后保留几位
     */
    public static double round(String v, int scale) throws IllegalAccessException {
        return div(v, "1", scale);
    }

    /**
     * 比较大小
     */
    public static boolean equalTo(BigDecimal b1, BigDecimal b2) {
        if (b1 == null || b2 == null) {
            return false;
        }
        return 0 == b1.compareTo(b2);
    }

    public static double format(double value) {
        return BigDecimal.valueOf(value).setScale(DEF_SCALE, BigDecimal.ROUND_HALF_UP).doubleValue();
    }

    public static double format(double value, int scale) {
        return BigDecimal.valueOf(value).setScale(scale, BigDecimal.ROUND_HALF_UP).doubleValue();
    }

}

package com.example.aesCipher;

import android.annotation.SuppressLint;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;

public class AES_ECB_Cipher {

    // 加密算法
    static final String CIPHER_NAME = "AES/ECB/PKCS5Padding";

    // 加密
    public static byte[] encrypt(byte[] key, byte[] input) throws NoSuchAlgorithmException, NoSuchPaddingException,
            InvalidKeyException, IllegalBlockSizeException, BadPaddingException {
        Cipher cipher = Cipher.getInstance(CIPHER_NAME);
        SecretKeySpec secretKeySpec = new SecretKeySpec(key, "AES");// byte[] key 转化为加密算饭AES的key
        cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec);// 加密模式
        return cipher.doFinal(input);
    }

    // 解密
    public static byte[] decrypt(byte[] key, byte[] input) throws NoSuchAlgorithmException, NoSuchPaddingException,
            InvalidKeyException, IllegalBlockSizeException, BadPaddingException {
        Cipher cipher = Cipher.getInstance(CIPHER_NAME);
        SecretKeySpec secretKeySpec = new SecretKeySpec(key, "AES");
        cipher.init(Cipher.DECRYPT_MODE, secretKeySpec);
        return cipher.doFinal(input);
    }

    @SuppressLint("NewApi")
    public static void main(String[] args) throws UnsupportedEncodingException, InvalidKeyException,
            NoSuchAlgorithmException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException {
        // 原文
        String message = "Hello,world! encrypted using AES!";
        byte[] data = message.getBytes(StandardCharsets.UTF_8);
        System.out.println("Message:" + message);
        // 128位密鈅=16bytes key：
        byte[] key = "1234567890abcdef".getBytes("UTF-8");
        // 加密
        byte[] encrypted = encrypt(key, data);
        System.out.println("Encrypted data:" + Base64.getEncoder().encodeToString(encrypted));// 转成BASE64

        // 解密
        byte[] decrypted = decrypt(key, encrypted);
        System.out.println("Decrypted data:" + new String(decrypted, "UTF-8"));
    }

}
package com.morel.greenhouse.application.service;

import com.morel.greenhouse.shared.exception.BusinessException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class VerificationDeliveryService {
    private static final Logger log = LoggerFactory.getLogger(VerificationDeliveryService.class);

    private final ObjectProvider<JavaMailSender> mailSenderProvider;
    private final String emailFrom;

    public VerificationDeliveryService(
            ObjectProvider<JavaMailSender> mailSenderProvider,
            @Value("${greenhouse.verification.email-from:}") String emailFrom
    ) {
        this.mailSenderProvider = mailSenderProvider;
        this.emailFrom = emailFrom;
    }

    public DeliveryResult deliverEmail(String receiver, String scene, String code) {
        if (receiver == null || !receiver.contains("@")) {
            throw new BusinessException(400, "验证码接收方必须是邮箱地址");
        }
        JavaMailSender mailSender = mailSenderProvider.getIfAvailable();
        if (mailSender == null || emailFrom == null || emailFrom.isBlank()) {
            log.warn("Email verification is not configured, fallback to development code. receiver={}, scene={}", receiver, scene);
            return DeliveryResult.dev("邮箱服务未配置，已生成开发验证码");
        }
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(emailFrom);
            message.setTo(receiver);
            message.setSubject("智慧羊肚菌大棚系统验证码");
            message.setText("您的验证码是：" + code + "，5 分钟内有效。若非本人操作，请忽略本邮件。");
            mailSender.send(message);
            log.info("Email verification code sent: receiver={}, scene={}", receiver, scene);
            return DeliveryResult.sent("验证码已发送至邮箱");
        } catch (Exception exception) {
            log.error("Failed to send email verification code: receiver={}, scene={}", receiver, scene, exception);
            throw new BusinessException(500, "邮件验证码发送失败，请检查 SMTP 配置");
        }
    }

    public record DeliveryResult(String message, boolean devMode) {
        static DeliveryResult sent(String message) {
            return new DeliveryResult(message, false);
        }

        static DeliveryResult dev(String message) {
            return new DeliveryResult(message, true);
        }
    }
}

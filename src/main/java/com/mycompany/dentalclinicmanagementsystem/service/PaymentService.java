package com.mycompany.dentalclinicmanagementsystem.service;

import com.mycompany.dentalclinicmanagementsystem.dao.InvoiceDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Invoice;
import com.mycompany.dentalclinicmanagementsystem.model.Payment;
import com.mycompany.dentalclinicmanagementsystem.util.VNPayConfig;

import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

public class PaymentService {

    private InvoiceDAO invoiceDAO;

    public PaymentService() {
        this.invoiceDAO = new InvoiceDAO();
    }

    public String createVNPayPaymentUrl(Invoice invoice, long amountVND, String ipAddress, String returnUrl) throws Exception {
        if (amountVND <= 0) {
            throw new Exception("Số tiền thanh toán phải lớn hơn 0.");
        }

        if (!"Unpaid".equals(invoice.getStatus())) {
            throw new Exception("Hóa đơn này đã được thanh toán hoặc đã bị hủy.");
        }

        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String orderType = "other";

        long amount = amountVND * 100;

        String vnp_TxnRef = "INV" + invoice.getInvoiceId() + "_" + VNPayConfig.getRandomNumber(8);
        String vnp_TmnCode = VNPayConfig.vnp_TmnCode;

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", "Thanh toan hoa don #" + invoice.getInvoiceCode());
        vnp_Params.put("vnp_OrderType", orderType);
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", returnUrl);
        vnp_Params.put("vnp_IpAddr", ipAddress);

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);
        
        List<String> hashDataList = new ArrayList<>();
        List<String> queryList = new ArrayList<>();

        for (String fieldName : fieldNames) {
            String fieldValue = vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                hashDataList.add(fieldName + "=" + URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString()));
                queryList.add(URLEncoder.encode(fieldName, StandardCharsets.UTF_8.toString()) 
                            + "=" 
                            + URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString()));
            }
        }

        String hashData = String.join("&", hashDataList);
        String queryUrl = String.join("&", queryList);
        
        String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.secretKey, hashData);
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        
        return VNPayConfig.vnp_PayUrl + "?" + queryUrl;
    }

    public PaymentReturnResult processVNPayReturn(Map<String, String> requestParams, int recordedBy) {
        Map<String, String> fields = new HashMap<>();
        for (Map.Entry<String, String> entry : requestParams.entrySet()) {
            String fieldName = entry.getKey();
            String fieldValue = entry.getValue();
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                try {
                    String encodedName = URLEncoder.encode(fieldName, StandardCharsets.UTF_8.toString());
                    String encodedValue = URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString());
                    fields.put(encodedName, encodedValue);
                } catch (Exception e) {
                    fields.put(fieldName, fieldValue);
                }
            }
        }

        String vnp_SecureHash = requestParams.get("vnp_SecureHash");

        try {
            String encodedHashType = URLEncoder.encode("vnp_SecureHashType", StandardCharsets.UTF_8.toString());
            String encodedHash = URLEncoder.encode("vnp_SecureHash", StandardCharsets.UTF_8.toString());
            if (fields.containsKey(encodedHashType)) {
                fields.remove(encodedHashType);
            }
            if (fields.containsKey(encodedHash)) {
                fields.remove(encodedHash);
            }
        } catch (Exception e) {
            fields.remove("vnp_SecureHashType");
            fields.remove("vnp_SecureHash");
        }

        String signValue = VNPayConfig.hashAllFields(fields);
        boolean isValidSignature = signValue.equals(vnp_SecureHash);

        String vnp_TxnRef = requestParams.get("vnp_TxnRef");
        String vnp_ResponseCode = requestParams.get("vnp_ResponseCode");
        String vnp_TransactionStatus = requestParams.get("vnp_TransactionStatus");
        String vnp_Amount = requestParams.get("vnp_Amount");

        int invoiceId = extractInvoiceIdFromTxnRef(vnp_TxnRef);

        if (invoiceId <= 0) {
            return new PaymentReturnResult(false, invoiceId, "Mã tham chiếu thanh toán không hợp lệ.");
        }

        if (isValidSignature) {
            if ("00".equals(vnp_ResponseCode) && "00".equals(vnp_TransactionStatus)) {
                Payment payment = new Payment();
                payment.setInvoiceId(invoiceId);
                payment.setAmount(new BigDecimal(vnp_Amount).divide(new BigDecimal("100")));
                payment.setPaymentMethod("Online Gateway");
                payment.setTransactionRef(vnp_TxnRef);
                payment.setRecordedBy(recordedBy);
                
                boolean success = invoiceDAO.addPayment(payment);
                
                if (success) {
                    return new PaymentReturnResult(true, invoiceId, "Thanh toán thành công qua VNPay.");
                } else {
                    return new PaymentReturnResult(false, invoiceId, "Lưu giao dịch thất bại. Vui lòng liên hệ hỗ trợ.");
                }
            } else {
                return new PaymentReturnResult(false, invoiceId, "Thanh toán thất bại: " + getVNPayErrorMessage(vnp_ResponseCode) + " (Mã: " + vnp_ResponseCode + ")");
            }
        } else {
            return new PaymentReturnResult(false, invoiceId, "Chữ ký thanh toán không hợp lệ. Giao dịch này có thể bị giả mạo.");
        }
    }

    private int extractInvoiceIdFromTxnRef(String txnRef) {
        try {
            if (txnRef != null && txnRef.startsWith("INV")) {
                String idPart = txnRef.substring(3);
                int underscoreIndex = idPart.indexOf('_');
                if (underscoreIndex > 0) {
                    return Integer.parseInt(idPart.substring(0, underscoreIndex));
                }
            }
        } catch (Exception e) {
            System.err.println("Failed to extract invoice ID from txn ref '" + txnRef + "': " + e.getMessage());
        }
        return 0;
    }

    private String getVNPayErrorMessage(String responseCode) {
        if (responseCode == null) return "Lỗi không xác định";
        switch (responseCode) {
            case "07": return "Giao dịch thành công nhưng bị từ chối bởi ngân hàng";
            case "09": return "Thẻ/Tài khoản chưa đăng ký dịch vụ Internet Banking";
            case "10": return "Xác thực thông tin thẻ/tài khoản không chính xác quá 3 lần";
            case "11": return "Giao dịch hết hạn. Vui lòng thử lại";
            case "12": return "Thẻ/Tài khoản bị khóa";
            case "13": return "Mã OTP không chính xác";
            case "24": return "Giao dịch bị hủy bởi người dùng";
            case "51": return "Tài khoản không đủ số dư";
            case "65": return "Vượt quá hạn mức giao dịch";
            case "75": return "Cổng thanh toán đang bảo trì";
            case "79": return "Giao dịch hết hạn, vui lòng thử lại";
            default: return "Giao dịch thất bại";
        }
    }

    public static class PaymentReturnResult {
        private boolean success;
        private int invoiceId;
        private String message;

        public PaymentReturnResult(boolean success, int invoiceId, String message) {
            this.success = success;
            this.invoiceId = invoiceId;
            this.message = message;
        }

        public boolean isSuccess() {
            return success;
        }

        public int getInvoiceId() {
            return invoiceId;
        }

        public String getMessage() {
            return message;
        }
    }
}

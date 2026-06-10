package com.mycompany.dentalclinicmanagementsystem.service;

import com.mycompany.dentalclinicmanagementsystem.dao.ServiceDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Service;
import java.util.List;

public class ClinicService {

    private ServiceDAO serviceDAO;

    public ClinicService() {
        this.serviceDAO = new ServiceDAO();
    }

    public List<Service> getAllServices(String search, String status, int offset, int limit) {
        return serviceDAO.getAllServices(search, status, offset, limit);
    }

    public int getTotalServices(String search, String status) {
        return serviceDAO.getTotalServices(search, status);
    }

    public Service getServiceById(int id) {
        return serviceDAO.getServiceById(id);
    }

    public void createService(Service service) throws Exception {
        validateService(service, null);
        boolean isSuccess = serviceDAO.createService(service);
        if (!isSuccess) {
            throw new Exception("Đã xảy ra lỗi hệ thống khi thêm dịch vụ. Vui lòng thử lại sau.");
        }
    }

    public void updateService(Service service) throws Exception {
        validateService(service, service.getServiceId());
        boolean isSuccess = serviceDAO.updateService(service);
        if (!isSuccess) {
            throw new Exception("Đã xảy ra lỗi hệ thống khi cập nhật dịch vụ. Vui lòng thử lại sau.");
        }
    }

    public void toggleServiceStatus(int id, boolean newStatus) throws Exception {
        boolean isSuccess = serviceDAO.toggleServiceStatus(id, newStatus);
        if (!isSuccess) {
            throw new Exception("Đã xảy ra lỗi khi thay đổi trạng thái dịch vụ.");
        }
    }

    public boolean isServiceCodeExists(String serviceCode, Integer excludeId) {
        if (serviceCode == null || serviceCode.trim().isEmpty()) {
            return false;
        }
        return serviceDAO.isServiceCodeExists(serviceCode.trim(), excludeId);
    }

    private void validateService(Service service, Integer excludeId) throws Exception {
        if (service.getServiceCode() == null || service.getServiceCode().trim().isEmpty()) {
            throw new Exception("Mã dịch vụ không được để trống.");
        }
        if (service.getServiceName() == null || service.getServiceName().trim().isEmpty()) {
            throw new Exception("Tên dịch vụ không được để trống.");
        }
        if (service.getListedPrice() == null || service.getListedPrice().compareTo(java.math.BigDecimal.ZERO) < 0) {
            throw new Exception("Giá niêm yết không hợp lệ.");
        }
        if (service.getEstimatedMinutes() != null && service.getEstimatedMinutes() <= 0) {
            throw new Exception("Thời gian dự kiến phải lớn hơn 0.");
        }
        
        if (isServiceCodeExists(service.getServiceCode(), excludeId)) {
            throw new Exception("Mã dịch vụ '" + service.getServiceCode() + "' đã tồn tại. Vui lòng chọn mã khác.");
        }
    }
}

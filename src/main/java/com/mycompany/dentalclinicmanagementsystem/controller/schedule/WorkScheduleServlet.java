package com.mycompany.dentalclinicmanagementsystem.controller.schedule;

import com.mycompany.dentalclinicmanagementsystem.dao.UserDAO;
import com.mycompany.dentalclinicmanagementsystem.dao.EmployeeScheduleDAO;
import com.mycompany.dentalclinicmanagementsystem.model.EmployeeSchedule;
import com.mycompany.dentalclinicmanagementsystem.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "WorkScheduleServlet", urlPatterns = {"/schedules"})
public class WorkScheduleServlet extends HttpServlet {

    private final EmployeeScheduleDAO employeeScheduleDAO = new EmployeeScheduleDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = loggedUser.getRoleName();
        if ("Customer".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này.");
            return;
        }

        // Get filter parameters
        String userIdStr = request.getParameter("userId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        Integer filterUserId = null;
        if ("Doctor".equalsIgnoreCase(role) || "Technician".equalsIgnoreCase(role) || "Receptionist".equalsIgnoreCase(role)) {
            // Employees (other than Admin) can only view their own schedule or maybe Receptionist can view all?
            // The previous logic allowed Receptionist to view all (because filterDoctorId was set to null if not Doctor and no doctorIdStr).
            // Let's keep Receptionist able to view all, but Doctor and Technician can only view their own.
            if ("Receptionist".equalsIgnoreCase(role)) {
                if (userIdStr != null && !userIdStr.isEmpty()) {
                    filterUserId = Integer.parseInt(userIdStr);
                }
            } else {
                filterUserId = loggedUser.getUserId();
            }
        } else if (userIdStr != null && !userIdStr.isEmpty()) {
            filterUserId = Integer.parseInt(userIdStr);
        }

        Date startDate = null;
        Date endDate = null;
        try {
            if (startDateStr != null && !startDateStr.isEmpty()) {
                startDate = Date.valueOf(startDateStr);
            } else {
                // Default to first day of current week
                LocalDate now = LocalDate.now();
                startDate = Date.valueOf(now.minusDays(now.getDayOfWeek().getValue() - 1));
            }

            if (endDateStr != null && !endDateStr.isEmpty()) {
                endDate = Date.valueOf(endDateStr);
            } else {
                // Default to last day of current week
                if (startDate != null) {
                    endDate = Date.valueOf(startDate.toLocalDate().plusDays(6));
                }
            }
        } catch (IllegalArgumentException e) {
            // Invalid date format
        }

        // Pagination parameters
        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                // Ignore invalid page param
            }
        }
        int offset = (page - 1) * pageSize;

        List<EmployeeSchedule> schedules = employeeScheduleDAO.getAllSchedules(filterUserId, startDate, endDate, offset, pageSize);
        int totalRecords = employeeScheduleDAO.getTotalSchedules(filterUserId, startDate, endDate);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        List<User> employees = userDAO.getAllEmployees();

        request.setAttribute("schedules", schedules);
        request.setAttribute("employees", employees);
        request.setAttribute("startDate", startDateStr); // Return strings to keep them in filter inputs
        request.setAttribute("endDate", endDateStr);
        request.setAttribute("filterUserId", filterUserId);
        
        request.setAttribute("activePage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/WEB-INF/views/schedule/schedule-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null || !"Admin".equalsIgnoreCase(loggedUser.getRoleName())) {
            session.setAttribute("errorMessage", "Chỉ Admin mới có quyền thay đổi lịch làm việc.");
            response.sendRedirect(request.getContextPath() + "/schedules");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/schedules");
            return;
        }

        try {
            if ("add".equals(action) || "update".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                Date workDate = Date.valueOf(request.getParameter("workDate"));
                String shift = request.getParameter("shift");
                Time startTime = Time.valueOf(request.getParameter("startTime") + ":00");
                Time endTime = Time.valueOf(request.getParameter("endTime") + ":00");
                boolean isDayOff = request.getParameter("isDayOff") != null;
                
                String maxPatientsStr = request.getParameter("maxPatients");
                int maxPatients = (maxPatientsStr != null && !maxPatientsStr.isEmpty()) ? Integer.parseInt(maxPatientsStr) : 0;

                EmployeeSchedule es = new EmployeeSchedule();
                es.setUserId(userId);
                es.setWorkDate(workDate);
                es.setShift(shift);
                es.setStartTime(startTime);
                es.setEndTime(endTime);
                es.setMaxPatients(maxPatients);
                es.setDayOff(isDayOff);

                if ("add".equals(action)) {
                    // Check duplicate shift
                    if (employeeScheduleDAO.getScheduleByEmployeeAndDateAndShift(userId, workDate, shift) != null) {
                        session.setAttribute("errorMessage", "Nhân viên đã có lịch làm việc trong ca này vào ngày đã chọn.");
                    } else if (employeeScheduleDAO.addSchedule(es)) {
                        session.setAttribute("successMessage", "Thêm lịch làm việc thành công.");
                    } else {
                        session.setAttribute("errorMessage", "Thêm lịch làm việc thất bại.");
                    }
                } else {
                    int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
                    es.setScheduleId(scheduleId);
                    if (employeeScheduleDAO.updateSchedule(es)) {
                        session.setAttribute("successMessage", "Cập nhật lịch làm việc thành công.");
                    } else {
                        session.setAttribute("errorMessage", "Cập nhật lịch làm việc thất bại.");
                    }
                }

            } else if ("delete".equals(action)) {
                int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
                if (employeeScheduleDAO.deleteSchedule(scheduleId)) {
                    session.setAttribute("successMessage", "Xóa lịch làm việc thành công.");
                } else {
                    session.setAttribute("errorMessage", "Xóa lịch làm việc thất bại.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/schedules");
    }
}

package com.mycompany.dentalclinicmanagementsystem.controller.api;

import com.mycompany.dentalclinicmanagementsystem.dao.AppointmentDAO;
import com.mycompany.dentalclinicmanagementsystem.dao.DoctorDAO;
import com.mycompany.dentalclinicmanagementsystem.dao.EmployeeScheduleDAO;
import com.mycompany.dentalclinicmanagementsystem.dao.ServiceDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Doctor;
import com.mycompany.dentalclinicmanagementsystem.model.EmployeeSchedule;
import com.mycompany.dentalclinicmanagementsystem.model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/api/doctor/slots")
public class DoctorSlotApiServlet extends HttpServlet {

    private DoctorDAO doctorDAO;
    private ServiceDAO serviceDAO;
    private EmployeeScheduleDAO employeeScheduleDAO;
    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
        serviceDAO = new ServiceDAO();
        employeeScheduleDAO = new EmployeeScheduleDAO();
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String serviceIdStr = request.getParameter("serviceId");
            int serviceId = (serviceIdStr != null && !serviceIdStr.isEmpty()) ? Integer.parseInt(serviceIdStr) : -1;
            String dateStr = request.getParameter("date"); // YYYY-MM-DD

            Doctor doctor = doctorDAO.getDoctorById(doctorId);
            if (doctor == null) {
                out.print("{\"status\":\"error\",\"message\":\"Doctor not found\"}");
                return;
            }

            int duration = 30;
            if (serviceId != -1) {
                Service service = serviceDAO.getServiceById(serviceId);
                if (service != null && service.getEstimatedMinutes() != null && service.getEstimatedMinutes() > 0) {
                    duration = service.getEstimatedMinutes();
                }
            }

            LocalDate localDate = LocalDate.parse(dateStr);
            Date sqlDate = Date.valueOf(localDate);

            List<EmployeeSchedule> schedules = employeeScheduleDAO.getAllSchedules(doctor.getUserId(), sqlDate, sqlDate, 0, 100);
            
            if (schedules == null || schedules.isEmpty()) {
                out.print("{\"status\":\"success\",\"slots\":[]}");
                return;
            }

            List<String> availableSlots = new ArrayList<>();
            LocalDateTime now = LocalDateTime.now();

            for (EmployeeSchedule es : schedules) {
                if (es.isDayOff()) continue;

                LocalTime startTime = es.getStartTime().toLocalTime();
                LocalTime endTime = es.getEndTime().toLocalTime();
                
                LocalTime current = startTime;

                while (current.plusMinutes(duration).isBefore(endTime) || current.plusMinutes(duration).equals(endTime)) {
                    LocalDateTime slotDateTime = LocalDateTime.of(localDate, current);
                    Timestamp slotTimestamp = Timestamp.valueOf(slotDateTime);

                    // Skip slots that have already passed if it's today
                    if (slotDateTime.isAfter(now)) {
                        boolean conflict = appointmentDAO.checkConflict(doctorId, slotTimestamp, duration);
                        if (!conflict) {
                            availableSlots.add(current.toString()); // format HH:mm
                        }
                    }
                    
                    // Increment by duration to pack slots tightly.
                    // Let's increment by a fixed interval like 30 mins to avoid weird times if duration is 45.
                    // For simplicity, stick to duration.
                    current = current.plusMinutes(duration);
                }
            }

            // Simple JSON array construction
            StringBuilder json = new StringBuilder("{\"status\":\"success\",\"slots\":[");
            for (int i = 0; i < availableSlots.size(); i++) {
                json.append("\"").append(availableSlots.get(i)).append("\"");
                if (i < availableSlots.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]}");
            
            out.print(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            out.print("[]");
        }
    }
}

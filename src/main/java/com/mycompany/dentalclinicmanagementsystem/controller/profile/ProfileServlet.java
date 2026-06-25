package com.mycompany.dentalclinicmanagementsystem.controller.profile;

import com.mycompany.dentalclinicmanagementsystem.dao.UserDAO;
import com.mycompany.dentalclinicmanagementsystem.model.User;
import com.mycompany.dentalclinicmanagementsystem.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ProfileServlet extends HttpServlet {
    private final UserService userService = new UserService();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Đảm bảo dữ liệu mới nhất
        User latestUser = userDAO.getUserById(loggedUser.getUserId());
        session.setAttribute("loggedUser", latestUser);

        request.getRequestDispatcher("/WEB-INF/views/profile/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("updateProfile".equals(action)) {
            handleUpdateProfile(request, response, loggedUser, session);
        } else if ("changePassword".equals(action)) {
            handleChangePassword(request, response, loggedUser, session);
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, User loggedUser, HttpSession session) throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");

        User updatedUser = new User();
        updatedUser.setUserId(loggedUser.getUserId());
        updatedUser.setFullName(fullName);
        updatedUser.setPhoneNumber(phoneNumber);
        updatedUser.setGender(gender);
        updatedUser.setEmail(loggedUser.getEmail()); // Email cannot be changed

        if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                java.util.Date parsedDate = sdf.parse(dateOfBirthStr);
                updatedUser.setDateOfBirth(new java.sql.Date(parsedDate.getTime()));
            } catch (Exception e) {
                // Ignore parsing error
            }
        }

        UserService.ProfileResult result = userService.processUpdateProfile(updatedUser);

        if (result.status == UserService.ProfileStatus.SUCCESS) {
            // Xử lý upload avatar
            Part avatarPart = request.getPart("avatar");
            if (avatarPart != null && avatarPart.getSize() > 0) {
                String fileName = getSubmittedFileName(avatarPart);
                if (fileName != null && !fileName.isEmpty()) {
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "images" + File.separator + "avatars";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    // Thư mục source code gốc để lưu vĩnh viễn trong quá trình code
                    String sourcePath = "c:\\Users\\admin\\Documents\\Support\\SWP\\DentalClinicManagementSystem\\src\\main\\webapp\\assets\\images\\avatars";
                    File sourceDir = new File(sourcePath);
                    if (!sourceDir.exists()) {
                        sourceDir.mkdirs();
                    }

                    // Tên file mới: user_id_timestamp.jpg
                    String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                    String newFileName = "user_" + loggedUser.getUserId() + "_" + System.currentTimeMillis() + fileExtension;
                    
                    // Lưu vào thư mục chạy thực tế (để web hiện ngay lập tức)
                    String savePath = uploadPath + File.separator + newFileName;
                    avatarPart.write(savePath);
                    
                    // Copy sang thư mục source code (để không bị mất khi Clean & Build)
                    try {
                        java.nio.file.Files.copy(
                            java.nio.file.Paths.get(savePath), 
                            java.nio.file.Paths.get(sourcePath + File.separator + newFileName),
                            java.nio.file.StandardCopyOption.REPLACE_EXISTING
                        );
                    } catch (Exception e) {
                        System.out.println("Lỗi copy ảnh sang source code: " + e.getMessage());
                    }
                    
                    String avatarUrl = "/assets/images/avatars/" + newFileName;
                    userService.processUpdateAvatar(loggedUser.getUserId(), avatarUrl);
                }
            }

            session.setAttribute("successMessage", result.message);
        } else {
            session.setAttribute("errorMessage", result.message);
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, User loggedUser, HttpSession session) throws IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        UserService.ProfileResult result = userService.processChangePassword(loggedUser.getUserId(), currentPassword, newPassword, confirmPassword);

        if (result.status == UserService.ProfileStatus.SUCCESS) {
            session.setAttribute("successMessage", result.message);
        } else {
            session.setAttribute("errorMessage", result.message);
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }

    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1); // MSIE fix.
            }
        }
        return null;
    }
}

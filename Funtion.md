Tính năng 1: Xác thực (5 UC)
ID
Use Case
Mô tả
UC01
Đăng ký tài khoản
Khách hàng tạo tài khoản mới và điền thông tin cá nhân cơ bản (họ tên, ngày sinh, giới tính).
UC02
Đăng nhập
Xác minh danh tính bằng tên đăng nhập/email và mật khẩu để truy cập hệ thống.
UC03
Đăng xuất
Kết thúc phiên làm việc hiện tại và thoát hệ thống an toàn.
UC04
Đặt lại mật khẩu
Yêu cầu liên kết khôi phục mật khẩu qua email; đặt mật khẩu mới sau khi xác minh danh tính.
UC05
Quản lý hồ sơ cá nhân
Xem và cập nhật thông tin cá nhân (họ tên, email, số điện thoại, ngày sinh, ảnh đại diện); đổi mật khẩu (yêu cầu xác nhận mật khẩu cũ).


Tính năng 2: Quản lý lịch hẹn (9 UC)
ID
Use Case
Mô tả
UC06
Đặt lịch hẹn trực tuyến
Khách hàng chọn dịch vụ, bác sĩ và ngày giờ khả dụng, sau đó đặt lịch. Hệ thống tạo lịch hẹn với trạng thái ban đầu là Mới.
UC07
Xem lịch hẹn của tôi
Khách hàng xem các lịch hẹn sắp tới và lịch sử khám trước đây, theo dõi trạng thái từng lịch hẹn.
UC08
Hủy hoặc dời lịch hẹn
Khách hàng hủy hoặc dời lịch hẹn trước giờ hẹn. Hệ thống tự động gửi email xác nhận.
UC09
Tạo lịch hẹn cho bệnh nhân đến trực tiếp hoặc đặt qua điện thoại
Lễ tân tạo lịch hẹn thay cho bệnh nhân gọi điện hoặc đến trực tiếp; chọn bác sĩ, dịch vụ, ngày giờ và nhập thông tin bệnh nhân.
UC10
Xem danh sách lịch hẹn trong ngày và hàng đợi chờ
Xem tất cả lịch hẹn trong ngày cùng hàng đợi chờ theo thời gian thực. Hỗ trợ lọc theo bác sĩ, trạng thái, dịch vụ và khung giờ; tìm kiếm nhanh theo tên hoặc mã bệnh nhân. Trạng thái cập nhật tự động; hiển thị số thứ tự và thời gian chờ dự kiến. Bác sĩ chỉ xem lịch của mình.
UC11
Gửi nhắc nhở lịch hẹn tự động qua email
Hệ thống tự động gửi email nhắc nhở trước 24 giờ và 2 giờ, đồng thời gửi email xác nhận ngay sau khi đặt lịch.
UC12
Check-in bệnh nhân
Xác nhận bệnh nhân đã đến và chuyển trạng thái lịch hẹn từ Mới sang Chờ khám; ghi lại giờ đến thực tế.
UC13
Bắt đầu khám
Cập nhật trạng thái lịch hẹn từ Chờ khám sang Đang khám khi gọi bệnh nhân vào; hệ thống ghi lại giờ bắt đầu thực tế.
UC16
Kết thúc khám
Bác sĩ hoàn tất lượt khám và xác nhận chẩn đoán cuối. Hệ thống chuyển trạng thái từ Đang khám sang Hoàn thành và lưu toàn bộ hồ sơ bệnh nhân.


Tính năng 3: Quản lý xét nghiệm và chẩn đoán hình ảnh (5 UC)
ID
Use Case
Mô tả
UC14
Chỉ định xét nghiệm hoặc chẩn đoán hình ảnh
Bác sĩ tạo lệnh xét nghiệm hoặc chẩn đoán hình ảnh (X-quang, xét nghiệm máu, CT scan,...) trong quá trình khám. Hệ thống chuyển trạng thái sang Đang xét nghiệm và gửi thông báo cho kỹ thuật viên.
UC15
Xác nhận hoàn thành xét nghiệm
Kỹ thuật viên cập nhật kết quả và tải lên file ảnh/kết quả. Hệ thống chuyển trạng thái sang Đang khám và thông báo cho bác sĩ.
UC24
Nhận lệnh xét nghiệm
Kỹ thuật viên xem danh sách lệnh từ bác sĩ; chi tiết gồm loại xét nghiệm/hình ảnh, tên bệnh nhân, bác sĩ yêu cầu và ghi chú ưu tiên.
UC25
Tải lên file kết quả và hình ảnh
Tải lên file kết quả (X-quang, CT scan, ảnh nội miệng, báo cáo xét nghiệm); liên kết với hồ sơ bệnh nhân và lượt khám tương ứng.
UC26
Thêm ghi chú vào kết quả xét nghiệm
Nhập mô tả và nhận xét kỹ thuật kèm file kết quả; đánh dấu hoàn thành để thông báo cho bác sĩ.


Tính năng 4: Quản lý hồ sơ bệnh nhân (3 UC)
ID
Use Case
Mô tả
UC17
Tạo hồ sơ bệnh nhân
Tạo hồ sơ mới cho bệnh nhân lần đầu; nhập thông tin cá nhân, tiền sử bệnh và dị ứng thuốc. Hệ thống tự sinh mã bệnh nhân theo định dạng PT-YYYY-XXXX.
UC18
Xem và tìm kiếm hồ sơ bệnh nhân
Tìm kiếm bệnh nhân theo tên, mã hoặc số điện thoại; xem tóm tắt hồ sơ. Bác sĩ xem đầy đủ lịch sử lâm sàng; lễ tân chỉ xem thông tin cơ bản.
UC20
Xem lịch sử khám
Xem toàn bộ lượt khám trước theo dạng timeline. Bác sĩ xem đầy đủ chi tiết lâm sàng; khách hàng chỉ xem tóm tắt và kết quả.


Tính năng 5: Khám lâm sàng (4 UC)
ID
Use Case
Mô tả
UC19
Ghi nhận kết quả khám
Nhập ghi chú lâm sàng, chẩn đoán, triệu chứng và tình trạng răng/nướu theo vị trí (sử dụng sơ đồ nha khoa); lưu vào hồ sơ lượt khám.
UC21
Kê đơn thuốc
Tạo đơn thuốc từ danh mục có sẵn hoặc nhập thủ công; chọn thuốc, liều lượng, thời gian và hướng dẫn sử dụng; lưu vào hồ sơ lượt khám.
UC22
Lập kế hoạch điều trị
Lên kế hoạch điều trị nhiều buổi (VD: niềng răng, tẩy trắng, cấy implant); liệt kê từng bước, chi phí dự kiến và lịch hẹn tiếp theo.
UC23
Xem kết quả khám và đơn thuốc
Khách hàng xem chẩn đoán, kết quả khám, đơn thuốc và kế hoạch điều trị qua ứng dụng sau khi lượt khám hoàn tất.


Tính năng 6: Quản lý lịch làm việc (3 UC)
ID
Use Case
Mô tả
UC27
Tạo và quản lý lịch làm việc bác sĩ
Thiết lập lịch làm việc theo ngày/tuần cho từng bác sĩ; cấu hình ca sáng/chiều, ngày nghỉ và số bệnh nhân tối đa mỗi khung giờ.
UC28
Xem lịch làm việc của tôi
Bác sĩ xem lịch theo ngày hoặc tuần; thấy các khung giờ đã đặt và còn trống; xem thông tin tóm tắt bệnh nhân trong ngày.
UC29
Xem khung giờ khả dụng để đặt lịch
Hiển thị các khung giờ còn trống theo bác sĩ và dịch vụ; dùng làm cơ sở để bệnh nhân đặt lịch hoặc lễ tân tư vấn.


Tính năng 7: Danh mục dịch vụ (1 UC)
ID
Use Case
Mô tả
UC31
Quản lý danh mục dịch vụ
Thêm, sửa và xóa dịch vụ (tên dịch vụ, thời gian dự kiến, giá niêm yết, mô tả); dịch vụ được dùng khi đặt lịch và xuất hóa đơn.


Tính năng 8: Quản lý nhân viên (2 UC)
ID
Use Case
Mô tả
UC30
Quản lý tài khoản nhân viên
Tạo, cập nhật và vô hiệu hóa tài khoản nhân viên (Lễ tân, Bác sĩ, Kỹ thuật viên); phân công vai trò và quyền hạn tương ứng.
UC43
Quản lý vai trò và phân quyền
Gán vai trò (Admin, Bác sĩ, Lễ tân, Kỹ thuật viên, Khách hàng) cho từng tài khoản; kiểm soát quyền truy cập từng tính năng theo vai trò.


Tính năng 9: Thanh toán và hóa đơn (6 UC)
ID
Use Case
Mô tả
UC32
Tạo hóa đơn
Tổng hợp các dịch vụ đã thực hiện trong lượt khám; tính tổng tiền, áp dụng khuyến mãi hoặc giảm giá; xuất hóa đơn để thanh toán.
UC33
Ghi nhận thanh toán
Ghi nhận phương thức thanh toán (tiền mặt, chuyển khoản, thẻ); xác nhận thanh toán thành công và lưu lịch sử giao dịch.
UC34
Xem hóa đơn và lịch sử thanh toán
Khách hàng xem hóa đơn theo từng lượt khám; xem chi tiết dịch vụ, số tiền và ngày thanh toán; tải hóa đơn dạng PDF.
UC35
Xem báo cáo và thống kê doanh thu
Xem doanh thu theo ngày/tháng/năm; phân tích theo dịch vụ, bác sĩ hoặc phương thức thanh toán; biểu đồ trực quan so sánh theo kỳ.
UC36
Xuất hóa đơn dạng PDF
In hoặc gửi email hóa đơn PDF cho bệnh nhân sau khi xác nhận thanh toán.
UC37
Thực hiện thanh toán
Khách hàng chọn thanh toán trực tuyến; hệ thống chuyển hướng đến cổng thanh toán để xử lý giao dịch; kết quả được trả về và trạng thái hóa đơn cập nhật thành Đã thanh toán.


Tính năng 10: Báo cáo (5 UC)
ID
Use Case
Mô tả
UC38
Xem tổng quan dashboard
Màn hình tóm tắt hiển thị số bệnh nhân trong ngày, số ca đang chờ/đang khám/hoàn thành, doanh thu ngày/tháng, tỷ lệ hoàn thành và đánh giá mới nhận.
UC39
Xem báo cáo lượt khám theo bác sĩ
So sánh số lượt khám, thời gian khám trung bình và đánh giá nhận được theo từng bác sĩ, theo tuần hoặc tháng.
UC40
Xem thống kê cá nhân của tôi
Bác sĩ xem thống kê của mình: tổng lượt khám, dịch vụ thực hiện nhiều nhất, đánh giá trung bình và đóng góp doanh thu.
UC41
Xem báo cáo dịch vụ phổ biến
Hiển thị các dịch vụ được sử dụng nhiều nhất theo thời gian; doanh thu theo dịch vụ; xu hướng sử dụng.
UC42
Xuất báo cáo ra Excel hoặc PDF
Xuất báo cáo đã lọc (doanh thu, lượt khám, dịch vụ,...) ra Excel hoặc PDF để lưu trữ hoặc trình bày.


Tính năng 11: Đánh giá (1 UC)
ID
Use Case
Mô tả
UC45
Gửi đánh giá sau khám
Khách hàng gửi đánh giá (1 đến 5 sao) và nhận xét về bác sĩ/dịch vụ sau khi lịch hẹn được đánh dấu Hoàn thành.


Tính năng 12: Quản lý ghế khám (3 UC) 
ID
Use Case
Mô tả
UC46
Quản lý ghế khám
Admin thêm, sửa, xóa ghế; gán ghế cố định cho từng bác sĩ (VD: Bác sĩ Minh → Ghế 01).
UC47
Xem bảng trạng thái ghế
Lễ tân xem trạng thái tất cả ghế theo thời gian thực: Trống / Đang dùng / Tạm trống (bệnh nhân đi xét nghiệm). Khi ghế Tạm trống, lễ tân có thể gọi bệnh nhân tiếp theo vào.
UC48
Cập nhật trạng thái ghế tự động
Hệ thống tự động cập nhật trạng thái ghế dựa theo hành động: bắt đầu khám (UC13) → Đang dùng; tạo lệnh xét nghiệm (UC14) → Tạm trống; xét nghiệm xong (UC15) → Đang dùng; kết thúc khám (UC16) → Trống.



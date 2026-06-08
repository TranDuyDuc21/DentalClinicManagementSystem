<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Confirm Modal Overlay -->
<div id="confirmModalOverlay" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(15, 23, 42, 0.4); backdrop-filter: blur(4px); z-index: 9999; justify-content: center; align-items: center; opacity: 0; transition: opacity 0.3s ease;">
    
    <!-- Confirm Modal Box -->
    <div id="confirmModalBox" style="background: white; border-radius: 12px; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04); width: 90%; max-width: 400px; padding: 24px; text-align: center; transform: translateY(-20px) scale(0.95); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);">
        
        <div style="width: 48px; height: 48px; border-radius: 50%; background: #fee2e2; color: #ef4444; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin: 0 auto 16px auto;">
            <i class="fa-solid fa-triangle-exclamation"></i>
        </div>

        <h3 id="confirmModalTitle" style="margin: 0 0 10px 0; color: #0f172a; font-size: 1.25rem; font-weight: 600;">Xác Nhận</h3>
        <p id="confirmModalMessage" style="margin: 0 0 24px 0; color: #64748b; font-size: 0.95rem; line-height: 1.5;">Bạn có chắc chắn muốn thực hiện hành động này không?</p>

        <div style="display: flex; gap: 12px; justify-content: center;">
            <button type="button" onclick="closeConfirmModal()" class="btn btn-outline-secondary" style="flex: 1; padding: 10px; font-weight: 500;">Hủy Bỏ</button>
            <button type="button" id="confirmModalBtn" class="btn btn-primary" style="flex: 1; padding: 10px; font-weight: 500;">Đồng Ý</button>
        </div>
    </div>
</div>

<script>
    let currentConfirmAction = null;

    function showConfirmModal(message, actionCallback, type = 'warning') {
        const overlay = document.getElementById('confirmModalOverlay');
        const box = document.getElementById('confirmModalBox');
        const msgEl = document.getElementById('confirmModalMessage');
        const iconEl = box.querySelector('.fa-solid');
        const iconContainer = iconEl.parentElement;
        const confirmBtn = document.getElementById('confirmModalBtn');

        // Set content
        msgEl.textContent = message;

        // Change styling based on type
        if (type === 'danger') {
            iconContainer.style.background = '#fee2e2';
            iconContainer.style.color = '#ef4444';
            iconEl.className = 'fa-solid fa-triangle-exclamation';
            confirmBtn.style.background = '#ef4444';
            confirmBtn.style.borderColor = '#ef4444';
        } else if (type === 'warning') {
            iconContainer.style.background = '#fef3c7';
            iconContainer.style.color = '#f59e0b';
            iconEl.className = 'fa-solid fa-circle-exclamation';
            confirmBtn.style.background = '#f59e0b';
            confirmBtn.style.borderColor = '#f59e0b';
        } else {
            iconContainer.style.background = '#dbeafe';
            iconContainer.style.color = '#3b82f6';
            iconEl.className = 'fa-solid fa-circle-question';
            confirmBtn.style.background = '#3b82f6';
            confirmBtn.style.borderColor = '#3b82f6';
        }

        currentConfirmAction = actionCallback;

        // Show modal with animation
        overlay.style.display = 'flex';
        // Trigger reflow
        void overlay.offsetWidth;
        
        overlay.style.opacity = '1';
        box.style.transform = 'translateY(0) scale(1)';
    }

    function closeConfirmModal() {
        const overlay = document.getElementById('confirmModalOverlay');
        const box = document.getElementById('confirmModalBox');
        
        overlay.style.opacity = '0';
        box.style.transform = 'translateY(-20px) scale(0.95)';
        
        setTimeout(() => {
            overlay.style.display = 'none';
            currentConfirmAction = null;
        }, 300);
    }

    document.getElementById('confirmModalBtn').addEventListener('click', function() {
        if (typeof currentConfirmAction === 'function') {
            currentConfirmAction();
        }
        closeConfirmModal();
    });

    // Close on click outside
    document.getElementById('confirmModalOverlay').addEventListener('click', function(e) {
        if (e.target === this) {
            closeConfirmModal();
        }
    });
</script>

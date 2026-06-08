<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Alert Modal Overlay -->
<div id="alertModalOverlay" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(15, 23, 42, 0.4); backdrop-filter: blur(4px); z-index: 9999; justify-content: center; align-items: center; opacity: 0; transition: opacity 0.3s ease;">
    
    <!-- Alert Modal Box -->
    <div id="alertModalBox" style="background: white; border-radius: 12px; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04); width: 90%; max-width: 400px; padding: 24px; text-align: center; transform: translateY(-20px) scale(0.95); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);">
        
        <div id="alertModalIconContainer" style="width: 48px; height: 48px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin: 0 auto 16px auto;">
            <i id="alertModalIcon" class="fa-solid fa-circle-info"></i>
        </div>

        <h3 id="alertModalTitle" style="margin: 0 0 10px 0; color: #0f172a; font-size: 1.25rem; font-weight: 600;">Thông báo</h3>
        <p id="alertModalMessage" style="margin: 0 0 24px 0; color: #64748b; font-size: 0.95rem; line-height: 1.5;"></p>

        <div style="display: flex; justify-content: center;">
            <button type="button" id="alertModalBtn" onclick="closeAlertModal()" class="btn btn-primary" style="min-width: 120px; padding: 10px; font-weight: 500;">OK</button>
        </div>
    </div>
</div>

<script>
    let currentAlertCallback = null;

    function showAlertModal(message, type = 'info', title = null, callback = null) {
        const overlay = document.getElementById('alertModalOverlay');
        const box = document.getElementById('alertModalBox');
        const msgEl = document.getElementById('alertModalMessage');
        const titleEl = document.getElementById('alertModalTitle');
        const iconEl = document.getElementById('alertModalIcon');
        const iconContainer = document.getElementById('alertModalIconContainer');
        const btn = document.getElementById('alertModalBtn');

        // Set content
        msgEl.textContent = message;
        currentAlertCallback = callback;

        // Configuration based on type
        const config = {
            success: {
                icon: 'fa-solid fa-circle-check',
                bg: '#dcfce7',
                color: '#22c55e',
                title: 'Thành Công'
            },
            error: {
                icon: 'fa-solid fa-circle-xmark',
                bg: '#fee2e2',
                color: '#ef4444',
                title: 'Lỗi'
            },
            warning: {
                icon: 'fa-solid fa-triangle-exclamation',
                bg: '#fef3c7',
                color: '#f59e0b',
                title: 'Cảnh Báo'
            },
            info: {
                icon: 'fa-solid fa-circle-info',
                bg: '#dbeafe',
                color: '#3b82f6',
                title: 'Thông Báo'
            }
        };

        const currentConfig = config[type] || config['info'];

        // Apply config
        titleEl.textContent = title || currentConfig.title;
        iconContainer.style.background = currentConfig.bg;
        iconContainer.style.color = currentConfig.color;
        iconEl.className = currentConfig.icon;
        
        btn.style.background = currentConfig.color;
        btn.style.borderColor = currentConfig.color;

        // Show modal with animation
        overlay.style.display = 'flex';
        // Trigger reflow
        void overlay.offsetWidth;
        
        overlay.style.opacity = '1';
        box.style.transform = 'translateY(0) scale(1)';
        
        // Focus the OK button so user can press Enter to dismiss
        setTimeout(() => btn.focus(), 300);
    }

    function closeAlertModal() {
        const overlay = document.getElementById('alertModalOverlay');
        const box = document.getElementById('alertModalBox');
        
        overlay.style.opacity = '0';
        box.style.transform = 'translateY(-20px) scale(0.95)';
        
        setTimeout(() => {
            overlay.style.display = 'none';
            if (typeof currentAlertCallback === 'function') {
                currentAlertCallback();
                currentAlertCallback = null;
            }
        }, 300);
    }

    // Close on click outside
    document.getElementById('alertModalOverlay').addEventListener('click', function(e) {
        if (e.target === this) {
            closeAlertModal();
        }
    });
</script>

const Utils = {
    showAlert(container, type, message) {
        const el = document.querySelector(container);
        if (!el) return;
        el.insertAdjacentHTML('afterbegin', `
            <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>`);
    },

    formatDate(dateStr) {
        if (!dateStr) return '';
        return new Date(dateStr).toLocaleDateString('vi-VN');
    },

    formatCurrency(amount) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency', currency: 'VND'
        }).format(amount);
    },

    confirm(message, onConfirm) {
        if (window.confirm(message)) onConfirm();
    }
};

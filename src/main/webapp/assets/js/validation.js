document.addEventListener('DOMContentLoaded', () => {
    
    const alerts = document.querySelectorAll('.alert');
    if (alerts.length > 0) {
        setTimeout(() => {
            alerts.forEach(alert => {
                alert.style.transition = "opacity 0.5s ease";
                alert.style.opacity = "0";
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);
    }

    const validateForms = document.querySelectorAll('.validate-form');
    validateForms.forEach(form => {
        form.addEventListener('submit', function(event) {
            let isValid = true;
            const requiredInputs = form.querySelectorAll('input[required], select[required], textarea[required]');
            
            requiredInputs.forEach(input => {
                if (!input.value.trim()) {
                    isValid = false;
                    showFieldError(input, 'Trường này không được để trống.');
                } else {
                    clearFieldError(input);
                }
            });

            if (!isValid) {
                event.preventDefault();
            }
        });
    });

    function showFieldError(inputElement, message) {
        let existingError = inputElement.parentElement.querySelector('.field-error');
        if (!existingError) {
            const errorElement = document.createElement('span');
            errorElement.className = 'field-error text-danger';
            errorElement.style.color = 'var(--error)';
            errorElement.style.fontSize = '0.85rem';
            errorElement.style.marginTop = '4px';
            errorElement.innerText = message;
            inputElement.parentElement.appendChild(errorElement);
            inputElement.style.borderColor = 'var(--error)';
        }
    }

    function clearFieldError(inputElement) {
        const errorElement = inputElement.parentElement.querySelector('.field-error');
        if (errorElement) {
            errorElement.remove();
            inputElement.style.borderColor = 'var(--border-color)';
        }
    }
});

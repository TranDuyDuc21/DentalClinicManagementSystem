/**
 * Dental Clinic - Reusable Form Validation Module
 */

document.addEventListener('DOMContentLoaded', () => {

    // 1. Auto dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    if (alerts.length > 0) {
        setTimeout(() => {
            alerts.forEach(alert => {
                alert.style.transition = "opacity 0.5s ease, transform 0.5s ease";
                alert.style.opacity = "0";
                alert.style.transform = "translateY(-10px)";
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);
    }

    // 2. Real-time Validation System
    const validateForms = document.querySelectorAll('.validate-form');

    const rules = {
        required: (value) => value.trim() !== '' || 'Trường này không được để trống.',
        email: (value) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value) || 'Email không hợp lệ.',
        phone: (value) => /^[0-9]{10,11}$/.test(value.replace(/[^0-9]/g, '')) || 'Số điện thoại không hợp lệ (10-11 số).',
        minLength: (value, min) => value.length >= parseInt(min) || `Phải có ít nhất ${min} ký tự.`,
        maxLength: (value, max) => value.length <= parseInt(max) || `Không được vượt quá ${max} ký tự.`,
        match: (value, targetId) => {
            const target = document.getElementById(targetId);
            return (target && value === target.value) || 'Mật khẩu nhập lại không khớp.';
        },
        username: (value) => /^[a-zA-Z0-9_]+$/.test(value) || 'Chỉ chấp nhận chữ cái, số và dấu gạch dưới.'
    };

    validateForms.forEach(form => {
        // Find all inputs that need validation
        const inputs = form.querySelectorAll('input, select, textarea');

        inputs.forEach(input => {
            // Real-time validation on blur and input
            input.addEventListener('blur', () => validateInput(input));
            input.addEventListener('input', () => {
                // Only validate on input if it already has an error, to clear it immediately when fixed
                if (input.classList.contains('is-invalid')) {
                    validateInput(input);
                }
            });
        });

        // Form submit validation
        form.addEventListener('submit', async function (event) {
            event.preventDefault(); // Prevent submit immediately to allow async checks
            let isValid = true;

            for (let input of inputs) {
                const result = await validateInputAsync(input);
                if (!result) {
                    isValid = false;
                }
            }

            if (isValid) {
                if (form.hasAttribute('data-ajax')) {
                    form.dispatchEvent(new Event('validSubmit', { bubbles: true, cancelable: true }));
                } else {
                    form.submit();
                }
            } else {
                const firstError = form.querySelector('.is-invalid');
                if (firstError) {
                    firstError.focus();
                }
            }
        });
    });

    async function validateInputAsync(input) {
        // Skip validation if input is not required and is empty (unless it has specific rules)
        if (!input.hasAttribute('required') && input.value.trim() === '' && !input.dataset.rule && !input.dataset.unique) {
            clearFieldError(input);
            return true;
        }

        let errorMessage = null;

        // 1. Check required
        if (input.hasAttribute('required') && input.value.trim() === '') {
            errorMessage = 'Trường này không được để trống.';
        }
        else if (input.value.trim() !== '') {
            // 2. Check data-rule (e.g. data-rule="email|phone|username")
            if (input.dataset.rule) {
                const appliedRules = input.dataset.rule.split('|');
                for (let rule of appliedRules) {
                    if (rules[rule]) {
                        const result = rules[rule](input.value);
                        if (result !== true) {
                            errorMessage = result;
                            break;
                        }
                    }
                }
            }

            // 3. Check minlength / maxlength attributes
            if (!errorMessage && input.hasAttribute('minlength')) {
                const result = rules.minLength(input.value, input.getAttribute('minlength'));
                if (result !== true) errorMessage = result;
            }

            // 4. Check data-match (for password confirmation)
            if (!errorMessage && input.dataset.match) {
                const result = rules.match(input.value, input.dataset.match);
                if (result !== true) errorMessage = result;
            }

            // 5. Check real-time uniqueness via API
            if (!errorMessage && input.dataset.unique) {
                try {
                    const field = input.dataset.unique;
                    const value = input.value.trim();
                    const excludeId = input.dataset.excludeId || '';

                    const url = `/DentalClinicManagementSystem/api/validate?field=${field}&value=${encodeURIComponent(value)}&excludeId=${excludeId}`;
                    const response = await fetch(url);
                    const data = await response.json();

                    if (data.exists) {
                        errorMessage = 'Dữ liệu này đã được sử dụng. Vui lòng chọn dữ liệu khác.';
                        if (field === 'email') errorMessage = 'Email này đã tồn tại trong hệ thống.';
                        if (field === 'phone') errorMessage = 'Số điện thoại này đã được đăng ký.';
                        if (field === 'username') errorMessage = 'Tên đăng nhập đã tồn tại.';
                    }
                } catch (e) {
                    console.error("Lỗi khi gọi API validate:", e);
                }
            }
        }

        if (errorMessage) {
            showFieldError(input, errorMessage);
            return false;
        } else {
            clearFieldError(input);
            input.classList.add('is-valid');
            return true;
        }
    }

    function validateInput(input) {
        validateInputAsync(input);
    }

    function showFieldError(inputElement, message) {
        inputElement.classList.remove('is-valid');
        inputElement.classList.add('is-invalid');

        let existingError = inputElement.parentElement.querySelector('.field-error');
        if (!existingError) {
            existingError = document.createElement('span');
            existingError.className = 'field-error';
            existingError.style.color = 'var(--error)';
            existingError.style.fontSize = '0.85rem';
            existingError.style.marginTop = '6px';
            existingError.style.display = 'block';
            existingError.style.animation = 'fadeIn 0.3s ease';
            inputElement.parentElement.appendChild(existingError);
        }
        existingError.innerText = message;
        inputElement.style.borderColor = 'var(--error)';
        inputElement.style.boxShadow = '0 0 0 3px rgba(239, 68, 68, 0.15)'; // Tailwind red-500 with opacity
    }

    function clearFieldError(inputElement) {
        inputElement.classList.remove('is-invalid');
        inputElement.style.borderColor = 'var(--border)'; // Default border
        inputElement.style.boxShadow = 'none';

        const errorElement = inputElement.parentElement.querySelector('.field-error');
        if (errorElement) {
            errorElement.remove();
        }
    }
});

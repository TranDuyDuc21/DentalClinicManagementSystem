document.addEventListener('DOMContentLoaded', function () {
    const toggle  = document.getElementById('sidebarToggle');
    const sidebar = document.getElementById('sidebar');
    const content = document.getElementById('page-content');

    if (!toggle || !sidebar || !content) return;

    toggle.addEventListener('click', function () {
        const isMobile = window.innerWidth <= 768;
        if (isMobile) {
            sidebar.classList.toggle('show');
        } else {
            sidebar.classList.toggle('collapsed');
            content.classList.toggle('expanded');
        }
    });

    // Close sidebar on mobile when clicking outside
    document.addEventListener('click', function (e) {
        if (window.innerWidth <= 768
            && !sidebar.contains(e.target)
            && !toggle.contains(e.target)) {
            sidebar.classList.remove('show');
        }
    });
});

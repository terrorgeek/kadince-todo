$(document).ready(function () {
  document.addEventListener('DOMContentLoaded', function() {
    const editTaskModal = document.getElementById('editTaskModal');
    editTaskModal.addEventListener('show.bs.modal', function (event) {
      const button = event.relatedTarget; // Button that triggered the modal
      const taskId = button.getAttribute('href').split('/').pop(); // Extract task ID from the edit link
      const modalBody = editTaskModal.querySelector('#editTaskFormContainer');
  
      fetch(`/tasks/${taskId}/edit`)
        .then(response => response.text())
        .then(html => {
          modalBody.innerHTML = html;
        });
    });
  });
});
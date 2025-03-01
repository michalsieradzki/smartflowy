import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.initDragAndDrop();
    this.initTaskCards();
  }

  initDragAndDrop() {
    const draggableTaskCards = document.querySelectorAll(".task-card.draggable");
    const allTaskCards = document.querySelectorAll(".task-card");
    const containers = document.querySelectorAll(".kanban-tasks-container");

    // Ustaw tylko karty z klasą 'draggable' jako faktycznie przeciągalne
    draggableTaskCards.forEach((card) => {
      card.setAttribute("draggable", true);
      
      card.addEventListener("dragstart", (e) => {
        card.classList.add("dragging");
        e.dataTransfer.setData("text/plain", card.dataset.taskId);
        e.dataTransfer.effectAllowed = "move";
      });
      
      card.addEventListener("dragend", () => {
        card.classList.remove("dragging");
        containers.forEach((container) => {
          container.classList.remove("highlight");
        });
      });
    });

    // Dodaj dodatkowe wizualne wskazówki dla kart, które można przeciągać
    draggableTaskCards.forEach((card) => {
      // Dodaj ikonę wskazującą na możliwość przeciągania
      const header = card.querySelector('.card-header');
      if (header) {
        const dragIcon = document.createElement('i');
        dragIcon.className = 'bi bi-arrows-move ms-2 drag-handle';
        dragIcon.style.opacity = '0.5';
        header.appendChild(dragIcon);
      }
      
      // Dodaj tooltip wyjaśniający
      card.setAttribute('title', 'Przeciągnij, aby zmienić status zadania');
    });

    // Dla nieprzeciągalnych kart dodaj wskazówkę wizualną
    allTaskCards.forEach((card) => {
      if (!card.classList.contains('draggable')) {
        card.classList.add('not-draggable');
      }
    });
    
    containers.forEach((container) => {
      container.addEventListener("dragover", (e) => {
        e.preventDefault();
        container.classList.add("highlight");
      });
      
      container.addEventListener("dragleave", () => {
        container.classList.remove("highlight");
      });
      
      container.addEventListener("drop", (e) => {
        e.preventDefault();
        container.classList.remove("highlight");
        
        const taskId = e.dataTransfer.getData("text/plain");
        const newStatus = container.closest(".kanban-column").dataset.status;
        
        this.updateTaskStatus(taskId, newStatus);
      });
    });
  }
  
  initTaskCards() {
    document.querySelectorAll(".task-card").forEach((card) => {
      card.addEventListener("click", (e) => {
        // Zatrzymujemy propagację, aby nie wywoływać zdarzenia click na kontenerze
        e.stopPropagation();
        
        const taskUrl = card.dataset.taskUrl;
        const modalBody = document.getElementById("task-details");
        const detailsLink = document.getElementById("task-details-link");
        
        // Ustawienie domyślnej zawartości podczas ładowania
        modalBody.innerHTML = '<div class="text-center py-4"><div class="spinner-border" role="status"><span class="visually-hidden">Ładowanie...</span></div></div>';
        
        // Pobieramy szczegółowe informacje o zadaniu
        fetch(taskUrl.replace(".json", ""))
          .then((response) => response.text())
          .then((html) => {
            // Wyciąganie tylko potrzebnej części HTML
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, "text/html");
            const taskDetails = doc.querySelector(".card-body");
            
            if (taskDetails) {
              modalBody.innerHTML = taskDetails.innerHTML;
            } else {
              modalBody.innerHTML = '<p class="text-danger">Nie udało się załadować szczegółów zadania.</p>';
            }
            
            // Aktualizacja linku do pełnych szczegółów
            detailsLink.href = taskUrl.replace(".json", "");
          })
          .catch(() => {
            modalBody.innerHTML = '<p class="text-danger">Wystąpił błąd podczas ładowania szczegółów zadania.</p>';
          });
      });
    });
  }
  
  updateTaskStatus(taskId, newStatus) {
    const csrfToken = document.querySelector("meta[name='csrf-token']").content;
    
    fetch("/kanban/update_status", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({
        task_id: taskId,
        status: newStatus
      })
    })
    .then((response) => {
      if (response.status === 403) {
        throw new Error("Brak uprawnień");
      }
      return response.json();
    })
    .then((data) => {
      if (data.success) {
        // Po udanym zaktualizowaniu statusu, odświeżamy widok
        window.location.reload();
      } else {
        const errorMsg = data.errors && data.errors.length > 0 
          ? data.errors.join(", ") 
          : "Nie udało się zmienić statusu zadania";
        alert(errorMsg);
      }
    })
    .catch((error) => {
      if (error.message === "Brak uprawnień") {
        alert("Nie masz uprawnień do zmiany statusu tego zadania");
      } else {
        alert("Wystąpił błąd podczas aktualizacji statusu zadania");
      }
    });
  }
}
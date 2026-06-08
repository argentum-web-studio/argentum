const packageButtons = document.querySelectorAll(".choose-package");
const form = document.querySelector("#inquiryForm");
const packageSelect = form?.querySelector('select[name="package"]');
const formNote = document.querySelector("#formNote");

packageButtons.forEach((button) => {
  button.addEventListener("click", () => {
    const selectedPackage = button.dataset.package;

    if (packageSelect && selectedPackage) {
      packageSelect.value = selectedPackage;
    }

    document.querySelector("#kontakt")?.scrollIntoView({ behavior: "smooth", block: "start" });
    form?.querySelector('input[name="name"]')?.focus({ preventScroll: true });
  });
});

form?.addEventListener("submit", (event) => {
  event.preventDefault();

  if (!form.checkValidity()) {
    form.reportValidity();
    return;
  }

  const data = new FormData(form);
  const subject = `Zapytanie - ${data.get("package")}`;
  const body = [
    `Imię i firma: ${data.get("name")}`,
    `E-mail: ${data.get("email")}`,
    `Pakiet: ${data.get("package")}`,
    "",
    "Wiadomość:",
    data.get("message"),
  ].join("\n");

  const mailto = `mailto:kontakt@argentum-web-studio.pl?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`;
  window.location.href = mailto;

  if (formNote) {
    formNote.textContent = "Otwieram program pocztowy z przygotowaną wiadomością.";
  }
});

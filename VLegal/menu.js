document.addEventListener("DOMContentLoaded", function () {
  var toggle = document.querySelector(".nav-toggle");
  var nav = document.getElementById("site-nav");
  if (!toggle || !nav) return;

  function closeNav() {
    nav.classList.remove("is-open");
    toggle.setAttribute("aria-expanded", "false");
    document.body.style.overflow = "";
  }

  toggle.addEventListener("click", function (e) {
    e.stopPropagation();
    var open = nav.classList.toggle("is-open");
    toggle.setAttribute("aria-expanded", open ? "true" : "false");
    document.body.style.overflow = open && window.innerWidth < 980 ? "hidden" : "";
  });

  nav.querySelectorAll("a").forEach(function (link) {
    link.addEventListener("click", closeNav);
  });

  document.addEventListener("click", function (e) {
    if (!nav.classList.contains("is-open")) return;
    if (nav.contains(e.target) || toggle.contains(e.target)) return;
    closeNav();
  });

  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") closeNav();
  });

  window.addEventListener("resize", function () {
    if (window.innerWidth >= 980) closeNav();
  });
});

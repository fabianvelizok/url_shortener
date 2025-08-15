import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dark-mode"
export default class extends Controller {
  static targets = ["icon"]

  connect() {
    const savedTheme = localStorage.getItem('theme')
    const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches

    if (savedTheme === 'dark' || (!savedTheme && systemPrefersDark)) {
      this.enableDarkMode()
    } else {
      this.enableLightMode()
    }
  }

  toggle() {
    if (document.documentElement.classList.contains('dark')) {
      this.enableLightMode()
      localStorage.setItem('theme', 'light')
    } else {
      this.enableDarkMode()
      localStorage.setItem('theme', 'dark')
    }
  }

  enableDarkMode() {
    document.documentElement.classList.add('dark')
    this.updateIcon('dark')
  }

  enableLightMode() {
    document.documentElement.classList.remove('dark')
    this.updateIcon('light')
  }

  updateIcon(mode) {
    if (this.hasIconTarget) {
      const iconElement = this.iconTarget
      if (mode === 'dark') {
        // Sun icon (currently dark, click to go light)
        iconElement.innerHTML = `
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"></path>
          </svg>
        `
      } else {
        // Moon icon (currently light, click to go dark)
        iconElement.innerHTML = `
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"></path>
          </svg>
        `
      }
    }
  }
}

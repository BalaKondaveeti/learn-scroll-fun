import tailwindcss from '@tailwindcss/vite'
import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// Served from https://<user>.github.io/learn-scroll-fun/, routing is hash-based.
export default defineConfig({
  base: '/learn-scroll-fun/',
  plugins: [react(), tailwindcss()],
})

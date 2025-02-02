
import { defineConfig } from 'vite'
import ViteRails from 'vite-plugin-rails'
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  clearScreen: false,
  plugins: [
		tailwindcss(),
    ViteRails({
			fullReload: {
        additionalPaths: ["config/routes.rb", "app/views/**/*"],
        delay: 300,
      },
		})
  ],
  root: "./app/assets",
  build: {
    manifest: true,
    rollupOptions: {
      input: "./app/frontend/entrypoints/application.js"
    }
  },
	css: {
    preprocessorOptions: {
      scss: {
        api: 'modern-compiler' // or "modern"
      }
    }
  }
})

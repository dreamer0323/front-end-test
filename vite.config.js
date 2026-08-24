// 配置Vite插件
import { defineConfig } from 'vite'
// 引入React插件
import react from '@vitejs/plugin-react'


export default defineConfig({
  // 配置React插件
  plugins: [react()],
});


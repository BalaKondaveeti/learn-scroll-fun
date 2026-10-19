import { HashRouter, Navigate, Route, Routes } from 'react-router-dom'
import { AuthProvider, RequireAuth } from './lib/auth'
import ChapterView from './pages/ChapterView'
import Home from './pages/Home'
import Login from './pages/Login'
import Review from './pages/Review'

export default function App() {
  return (
    <AuthProvider>
      <HashRouter>
        <Routes>
          <Route path="/login" element={<Login />} />
          <Route element={<RequireAuth />}>
            <Route path="/" element={<Home />} />
            <Route path="/c/:chapterSlug" element={<ChapterView />} />
            <Route path="/c/:chapterSlug/p/:partSlug" element={<ChapterView />} />
            <Route path="/review" element={<Review />} />
          </Route>
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </HashRouter>
    </AuthProvider>
  )
}

import { useState } from 'react'
import './App.css'

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'https://httpbin.org'

function App() {
  const [loading, setLoading] = useState(false)
  const [activeTarget, setActiveTarget] = useState(null)
  const [response, setResponse] = useState(null)
  const [error, setError] = useState(null)

  const handleFetch = async (endpoint, label) => {
    setLoading(true)
    setActiveTarget(label)
    setError(null)
    setResponse(null)

    try {
      const url = `${API_BASE_URL.replace(/\/$/, '')}/${endpoint}`
      const res = await fetch(url)
      
      if (!res.ok) {
        throw new Error(`HTTP Error ${res.status}: ${res.statusText}`)
      }

      const data = await res.json()
      setResponse(data)
    } catch (err) {
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="container">
      <header>
        <h1>DevOps Lab Frontend</h1>
        <p>Select an option to hit the backend API</p>
      </header>

      <div className="button-group">
        <button 
          className="btn btn-a"
          disabled={loading}
          onClick={() => handleFetch('apple', 'Option A (/apple)')}
        >
          {loading && activeTarget === 'Option A (/apple)' ? 'Connecting...' : 'Option A: /apple'}
        </button>

        <button 
          className="btn btn-b"
          disabled={loading}
          onClick={() => handleFetch('bomb', 'Option B (/bomb)')}
        >
          {loading && activeTarget === 'Option B (/bomb)' ? 'Connecting...' : 'Option B: /bomb'}
        </button>
      </div>

      <div className="results-card">
        <h3>Request Status: {activeTarget ? activeTarget : 'None Selected'}</h3>
        
        {loading && <div className="loader">Sending request...</div>}

        {error && (
          <div className="error-box">
            <strong>Error:</strong> {error}
          </div>
        )}

        {response && (
          <div className="response-box">
            <h4>Backend Response:</h4>
            <pre>{JSON.stringify(response, null, 2)}</pre>
          </div>
        )}
      </div>
    </div>
  )
}

export default App
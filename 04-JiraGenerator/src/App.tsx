import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import { api } from './01-Api/Api'

function App() {
  const [count, setCount] = useState(0)



  return (
    <>
      <button onClick={()=>{
        api.getState();
      }}>Test</button>
    </>
  )
}

export default App

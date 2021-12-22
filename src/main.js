import * as riot from 'riot'
import App from './components/app.riot'

const mountApp = riot.component(App)

function createAppProps() {
  const props = {
    min: 3.6,
    max: 6.6,
    increment: 0.15,
    ohms: null
  }
  for (const [ key, value ] of new URLSearchParams(location.search)) {
    if (!props.hasOwnProperty(key)) {
      continue
    }
    const valueNum = Number(value)
    if (!Number.isNaN(valueNum)) {
      props[key] = valueNum
    }
  }
  return props
}

const app = mountApp(document.getElementById('app-root'), createAppProps())

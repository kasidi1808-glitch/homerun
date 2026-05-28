const trimTrailingSlash = (value: string) => value.replace(/\/+$/, '')

const rawApiBase = (import.meta.env.VITE_API_BASE_URL as string | undefined)?.trim()
const rawWsBase = (import.meta.env.VITE_WS_BASE_URL as string | undefined)?.trim()

export const API_BASE_URL = rawApiBase ? trimTrailingSlash(rawApiBase) : '/api'

export const WS_BASE_URL = rawWsBase
  ? trimTrailingSlash(rawWsBase)
  : undefined

export const withApiPath = (path: string) => {
  const normalized = path.startsWith('/') ? path : `/${path}`
  if (API_BASE_URL === '/api') return normalized
  return `${API_BASE_URL}${normalized}`
}

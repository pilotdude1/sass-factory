const CACHE_NAME = 'sass-factory-v1';
const urlsToCache = [
	'/',
	'/manifest.json',
	'/icons/icon-192x192.png',
	'/icons/icon-512x512.png',
	'/favicon.png',
	'/screenshots/desktop-1.png',
	'/screenshots/desktop-2.png',
	'/screenshots/mobile-1.png',
	'/screenshots/mobile-2.png'
];

// Install event - cache assets
self.addEventListener('install', (event) => {
	event.waitUntil(
		caches
			.open(CACHE_NAME)
			.then((cache) => {
				console.log('Opened cache');
				return cache.addAll(urlsToCache);
			})
			.then(() => self.skipWaiting())
	);
});

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
	event.waitUntil(
		caches
			.keys()
			.then((cacheNames) => {
				return Promise.all(
					cacheNames.map((cacheName) => {
						if (cacheName !== CACHE_NAME) {
							return caches.delete(cacheName);
						}
					})
				);
			})
			.then(() => self.clients.claim())
	);
});

// Fetch event - network first, then cache
self.addEventListener('fetch', (event) => {
	event.respondWith(
		fetch(event.request)
			.then((response) => {
				// Check if we received a valid response
				if (!response || response.status !== 200 || response.type !== 'basic') {
					return response;
				}

				// Clone the response
				const responseToCache = response.clone();

				caches.open(CACHE_NAME).then((cache) => {
					cache.put(event.request, responseToCache);
				});

				return response;
			})
			.catch(() => {
				// If network fails, try to get from cache
				return caches.match(event.request);
			})
	);
});

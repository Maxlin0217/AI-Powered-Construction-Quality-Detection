// service-worker.js
const CACHE_NAME = 'yolo-detection-v1';
const urlsToCache = [
  '/yolo-smart-detection.html',
  '/yolo-extended-detection.html',
  '/yolo-final-fixed.html',
  '/ort.min.js',
  '/ort-wasm-simd-threaded.mjs',
  '/ort-wasm-simd-threaded.wasm',
  '/ort-wasm-simd.mjs',
  '/ort-wasm-simd.wasm',
  '/best.onnx'
];

// 安裝 Service Worker
self.addEventListener('install', event => {
  console.log('Service Worker 安裝中...');
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        console.log('快取檔案中...');
        return cache.addAll(urlsToCache);
      })
      .catch(err => {
        console.error('快取失敗:', err);
        // 不阻止安裝，部分檔案可能不存在
        return Promise.resolve();
      })
  );
});

// 啟用 Service Worker
self.addEventListener('activate', event => {
  console.log('Service Worker 已啟用');
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            console.log('刪除舊快取:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});

// 攔截請求，優先使用快取
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        // 快取命中，返回快取
        if (response) {
          console.log('使用快取:', event.request.url);
          return response;
        }
        
        // 未命中，發送網路請求
        console.log('網路請求:', event.request.url);
        return fetch(event.request)
          .then(response => {
            // 檢查是否為有效響應
            if (!response || response.status !== 200 || response.type !== 'basic') {
              return response;
            }
            
            // 克隆響應並加入快取
            const responseToCache = response.clone();
            caches.open(CACHE_NAME)
              .then(cache => {
                cache.put(event.request, responseToCache);
              });
            
            return response;
          })
          .catch(err => {
            console.error('網路請求失敗:', err);
            // 返回離線頁面或默認內容
            return new Response('離線模式 - 請檢查網路連線', {
              status: 503,
              statusText: 'Service Unavailable',
              headers: new Headers({
                'Content-Type': 'text/plain'
              })
            });
          });
      })
  );
});

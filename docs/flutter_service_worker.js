'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "555a77be4890c11b4dfe99e053e95033",
"assets/AssetManifest.bin.json": "1ba5da34eab901a9eb194ac46418a37a",
"assets/AssetManifest.json": "8016c2200052b38d44ad3aa2d51c7487",
"assets/assets/fonts/Permanent_Marker/PermanentMarker-Regular.ttf": "c863f8028c2505f92540e0ba7c379002",
"assets/assets/images/2x/back.png": "85cda8f41a13153d6f3fb1c403f272ea",
"assets/assets/images/2x/restart.png": "83aea4677055df9b0d8171f5315f2a60",
"assets/assets/images/2x/settings.png": "8404e18c68ba99ca0b181bd96ace0376",
"assets/assets/images/3.5x/back.png": "85db134e26410547037485447f659277",
"assets/assets/images/3.5x/restart.png": "583169ac365d9515fc12f29e3b530de0",
"assets/assets/images/3.5x/settings.png": "c977a1e6c59e8cfd5cd88a0c973928fc",
"assets/assets/images/3x/back.png": "88a977a654df5a490037340f90a5a19e",
"assets/assets/images/3x/restart.png": "429270ce832c881b80fbd592e5ff1e0e",
"assets/assets/images/3x/settings.png": "21ff2cc135a762f74ed1a80aac6502bb",
"assets/assets/images/back.png": "3c82301693d5c4140786184a06c23f7e",
"assets/assets/images/background/1.png": "439e8af36c693659fc801e400acf37c1",
"assets/assets/images/background/2.png": "0990c9f22ed6723054fab28fcd523de4",
"assets/assets/images/background/3.png": "c3d84f54ef6f0ab992ee68216e9144c6",
"assets/assets/images/background/4.png": "c895f3755c8727acfbf660e3935ad46d",
"assets/assets/images/background/5.png": "7c4fa831ad892f7a532ed0ceed2329f0",
"assets/assets/images/blahblahblahmus.png": "0c431e8c93aa66757b4ba8fd0b82dba3",
"assets/assets/images/block.png": "6f13e4c9157f5945af01f42effae3138",
"assets/assets/images/character/climb.png": "e06ddf4281b2b57926545c663b54b626",
"assets/assets/images/character/death.png": "17323c2f195f1df4d6fce68ec2bc625e",
"assets/assets/images/character/hurt.png": "e68305f0fad0b262df5017d2563ee214",
"assets/assets/images/character/idle.png": "5de004b1f99e6e115e13c0325504c728",
"assets/assets/images/character/jump.png": "3b5c3f6ea0151b0f4544b049d9be98d0",
"assets/assets/images/character/run.png": "31268c2bca56bb3d2129a2942e965c5e",
"assets/assets/images/cutscenes/intro_1.png": "9ba1246bb91abfb98ae0e186d8051b7b",
"assets/assets/images/cutscenes/intro_2.png": "cbd8af4a63a1bb2fde360caae9d42689",
"assets/assets/images/cutscenes/intro_3.png": "adac892f60cddd8067939d09f4265ce1",
"assets/assets/images/cutscenes/intro_4.png": "e75a72177b2546b23ae64cef32df9647",
"assets/assets/images/cutscenes/intro_5.png": "9f307f3006b607a3d44fa0abcb0604f3",
"assets/assets/images/cutscenes/intro_6.png": "9a9dc8ad0e1eff1de88ac6ac6b840bf3",
"assets/assets/images/cutscenes/outro_1.png": "93b52853417c261009f565f0a3d65cc7",
"assets/assets/images/cutscenes/outro_2.png": "114882242be110111e34f11697dd4900",
"assets/assets/images/cutscenes/outro_3.png": "d4ea672f371b75f81ea47500a1b7d000",
"assets/assets/images/cutscenes/outro_4.png": "0dfd0c6f1a6f156cccb4925612c5a87d",
"assets/assets/images/cutscenes/outro_5.png": "fb75f8e9a0e6c29a74b2ada2c486a682",
"assets/assets/images/cutscenes/theend.png": "dd8f2c2ecb196a72546124e554ecc432",
"assets/assets/images/enemy/Walk.png": "e50c734faf4a6f5776145d9b19907480",
"assets/assets/images/enemy2/Walk.png": "1071d8b2daa2e0a1e0b402267ee67933",
"assets/assets/images/frogg_merchant.gif": "6bc316eb130d9186edfa207c9eec956e",
"assets/assets/images/frogshop.png": "a77db1ebf8d4e25dc867ff965bcd6c36",
"assets/assets/images/frog_shop.png": "0e17dbac435127383835e9d16a9f7599",
"assets/assets/images/gate.png": "1ba3248439d400cc201b129da8d366fc",
"assets/assets/images/ground.png": "b61b5db587df3198d5876c66f9614f46",
"assets/assets/images/hobo.png": "d8d4abb79d2d383b119568ed56923c20",
"assets/assets/images/hulajka.png": "4e7b21bf82b91517723a08ab65ee0564",
"assets/assets/images/Money.png": "27629a8c7ce62256ccf07f293d663ada",
"assets/assets/images/restart.png": "d3d2e3f3b2f6cb1e1a69b8b2529096f7",
"assets/assets/images/settings.png": "840fd7e3337c743046bf992ef18a10b8",
"assets/assets/images/shop/monsterek.png": "b800571136254cbf621ad85d59513aa1",
"assets/assets/images/shop/specek.png": "9477aa00bda287b8a1c068e3bdf5e420",
"assets/assets/images/shop/szlugi.png": "6b31707ddfc605ad3d0b25207e40d581",
"assets/assets/images/specek.png": "022b80aa6af2e905cdbf9c55be1b70c4",
"assets/assets/images/splash.png": "2e175cae0ceece9287b21ad3ed43cdf4",
"assets/assets/images/static_money.png": "441eae48fedf89a8910683cf120d1795",
"assets/assets/images/street.png": "f35da93b87aad681dda4cc05c5b7237a",
"assets/assets/images/wall.png": "e6a7ffbe6ab3c3956a1122a49c5e2cb0",
"assets/assets/images/wodiczka.png": "79c21f45787c121422b0a81760919ce0",
"assets/assets/images/youdied.jpg": "7b11b5416ad43dfd31917345fc7b4663",
"assets/assets/images/zapps.png": "852fa0097aefc4a6bb0983eafa6e9f35",
"assets/assets/images/zbita_butelka.png": "bfeb1c946c2475fb7572f280473f765e",
"assets/assets/levels/%25C5%25BCabianka.bmp": "3c0fdcf01f767becff650ec5250faadd",
"assets/assets/levels/%25C5%25BCabianka.json": "aa38f94c717052e4dab931cef41c53b6",
"assets/assets/levels/level.bmp": "bb4f39ea963f845f6567c627e7dbd513",
"assets/assets/levels/level.json": "f7c881c20fc508a6ff0db30809f560e7",
"assets/assets/levels/long_tower.bmp": "e486ebd968e0424a0bbc9ab665f04b1d",
"assets/assets/levels/long_tower.json": "4df6eda1c07d845aa15c60316ab3c596",
"assets/assets/levels/scooter_level.bmp": "cbf11bdaf0de12f354b79b0177e826c8",
"assets/assets/levels/scooter_level.json": "e46a505e21f6d68edb9e4b1a66ef92f6",
"assets/assets/levels/skurwiel_tower.bmp": "7e3c71641258754e0255a43810ad986c",
"assets/assets/levels/skurwiel_tower.json": "fe07b38363a421800702a3450de97f9d",
"assets/assets/levels/tower_level.bmp": "83751a249c5ff84fd7d0d1612e020436",
"assets/assets/levels/tower_level.json": "4ff65f47292a80468f938e972f6596b4",
"assets/assets/levels/tutorial.bmp": "59843eb77dfd3a84fe141ea85885a074",
"assets/assets/levels/tutorial.json": "6058789a620741da89261cd2fcfa28ea",
"assets/assets/levels/_level_list.json": "76d6e5d2df588cc99351b8c1a66f039e",
"assets/assets/music/A%2520Brief%2520Respite%2520(Camp%2520Theme).mp3": "8a982296f70b801ba46a9201c2039a25",
"assets/assets/music/ending.mp3": "62aa8f949507adae635ac28dabc3aa5f",
"assets/assets/music/intro.mp3": "6e5d61b1f3eca24ec5a06aa10ad9bba6",
"assets/assets/music/level1.mp3": "fbdbc92e6626288b4a4e26d837614834",
"assets/assets/music/README.md": "5047154cbbd54e90f4cbf3fb248e53fb",
"assets/assets/music/scooter_level.mp3": "46569dc95a9cbeda8bc25b7d3f5dc5bb",
"assets/assets/sfx/animal%2520crossing%2520talk.mp3": "06b140c5633f1e0ded4ae7dc09b16f99",
"assets/assets/sfx/blahblahblahmus.mp3": "694d6bafb06821117b0b823888dff138",
"assets/assets/sfx/bonk1.m4a": "46499c5b37c7c913f1e69561498db697",
"assets/assets/sfx/bonk2.flac": "474dfb926f329688b5c3d9082b9769c1",
"assets/assets/sfx/bonk3.flac": "26a6db6f719b5ea2b6594e6f08d5254f",
"assets/assets/sfx/bonk4.flac": "0210e3d3078d55452b23cc050731898c",
"assets/assets/sfx/bonk5.flac": "1aff4cf1946e9a7d36f170b6e1854466",
"assets/assets/sfx/dsht1.mp3": "c99ece72f0957a9eaf52ade494465946",
"assets/assets/sfx/ehehee1.mp3": "52f5042736fa3f4d4198b97fe50ce7f3",
"assets/assets/sfx/fwfwfwfw1.mp3": "d0f7ee0256d1f0d40d77a1264f23342b",
"assets/assets/sfx/fwfwfwfwfw1.mp3": "46355605b43594b67a39170f89141dc1",
"assets/assets/sfx/hash1.mp3": "f444469cd7a5a27062580ecd2b481770",
"assets/assets/sfx/hash2.mp3": "d26cb7676c3c0d13a78799b3ccac4103",
"assets/assets/sfx/hash3.mp3": "38aad045fbbf951bf5e4ca882b56245e",
"assets/assets/sfx/haw1.mp3": "00db66b69283acb63a887136dfe7a73c",
"assets/assets/sfx/hh1.mp3": "fab21158730b078ce90568ce2055db07",
"assets/assets/sfx/hh2.mp3": "4d39e7365b89c74db536c32dfe35580b",
"assets/assets/sfx/k1.mp3": "37ffb6f8c0435298b0a02e4e302e5b1f",
"assets/assets/sfx/k2.mp3": "8ec44723c33a1e41f9a96d6bbecde6b9",
"assets/assets/sfx/kch1.mp3": "a832ed0c8798b4ec95c929a5b0cabd3f",
"assets/assets/sfx/kss1.mp3": "fd0664b62bb9205c1ba6868d2d185897",
"assets/assets/sfx/lalala1.mp3": "b0b85bf59814b014ff48d6d79275ecfd",
"assets/assets/sfx/metal_steps_01.wav": "8b6306ab2ef5c9217cf2f8adfc628332",
"assets/assets/sfx/metal_steps_02.wav": "fe0b39bb98e3d2138bd2569a941e1c8e",
"assets/assets/sfx/metal_steps_03.wav": "b32bd3323c840f322a78a3d614f19c9f",
"assets/assets/sfx/metal_steps_04.wav": "ed2abe1250954b914463090ddadb8655",
"assets/assets/sfx/metal_steps_05.wav": "f173d04b04321e922c9ffef3baef5c35",
"assets/assets/sfx/metal_steps_06.wav": "81bda54f41a975b5c813a62a2379a23b",
"assets/assets/sfx/metal_steps_07.wav": "4517b7593672babf08c38ff37c6d8d5c",
"assets/assets/sfx/metal_steps_08.wav": "108a4c9c32116d5192991b003c8a2cb9",
"assets/assets/sfx/metal_steps_09.wav": "f3c541a62fc1994bd26dffec91026dfb",
"assets/assets/sfx/metal_steps_10.wav": "a3e208baa002a33018813fc885aece07",
"assets/assets/sfx/oo1.mp3": "94b9149911d0f2de8f3880c524b93683",
"assets/assets/sfx/p1.mp3": "ad28c0d29ac9e8adf9a91a46bfbfac82",
"assets/assets/sfx/p2.mp3": "ab829255f1ef20fbd4340a7c9e5157ad",
"assets/assets/sfx/pain1.wav": "909815ac5e5108c5ecbb8982ab8f9f4e",
"assets/assets/sfx/pain2.wav": "1a73799d220a696cadf8067a93ca89bf",
"assets/assets/sfx/pain3.wav": "197b447e62067f571c2af62e9b931fb9",
"assets/assets/sfx/pain4.wav": "1c8556531a6082ef226f91d72ded7093",
"assets/assets/sfx/pain5.wav": "02c17b47b2a8e9670ba38bfe05135ebb",
"assets/assets/sfx/pain6.wav": "162ae0c5bf8704c9ca71c8e25e6cb225",
"assets/assets/sfx/README.md": "2db52900312b320724a357f554f7595e",
"assets/assets/sfx/sh1.mp3": "f695db540ae0ea850ecbb341a825a47b",
"assets/assets/sfx/sh2.mp3": "e3212b9a7d1456ecda26fdc263ddd3d0",
"assets/assets/sfx/slightscream-08.flac": "8583c2ecc19f6bd4308f7d4f20be820c",
"assets/assets/sfx/slightscream-09.flac": "efc7781b1aa558f3c15b35acc6a20f7a",
"assets/assets/sfx/slightscream-10.flac": "df4d27bdbab6501f7ca5d7d597bb4dbd",
"assets/assets/sfx/slightscream-11.flac": "ebbfb9a5ce4669180fbdd2606bd2edaa",
"assets/assets/sfx/slightscream-12.flac": "573211a5fd8ed852f64c9326779af404",
"assets/assets/sfx/slightscream-13.flac": "c6889aaf000ae232db1d5f495e54bb4a",
"assets/assets/sfx/slightscream-14.flac": "38e7acf88e1fcc51e1c13cdcad749aea",
"assets/assets/sfx/slightscream-15.flac": "73cf03f1e841d31bb0880e599353e538",
"assets/assets/sfx/spsh1.mp3": "2e1354f39a5988afabb2fdd27cba63e1",
"assets/assets/sfx/swishswish1.mp3": "219b0f5c2deec2eda0a9e0e941894cb6",
"assets/assets/sfx/tires_squal_loop.m4a": "df8ebd4fea8ba334404e4d84454d9df0",
"assets/assets/sfx/wehee1.mp3": "5a986231104c9f084104e5ee1c564bc4",
"assets/assets/sfx/ws1.mp3": "5cfa8fda1ee940e65a19391ddef4d477",
"assets/assets/sfx/wssh1.mp3": "cf92e8d8483097569e3278c82ac9f871",
"assets/assets/sfx/wssh2.mp3": "255c455d9692c697400696cbb28511cc",
"assets/assets/sfx/yay1.mp3": "8d3b940e33ccfec612d06a41ae616f71",
"assets/assets/sfx/yoda.mp3": "dfb4a5122c964a45d83ac556ee0ae629",
"assets/assets/sfx/youdied.m4a": "9eddf7068f3dce12f130179673f4e570",
"assets/assets/sfx/you_died.mp3": "0c30d4bb60c1c7886f3ac29ca06439ad",
"assets/FontManifest.json": "806f6b30fc84741899cf1b932dbce0fd",
"assets/fonts/MaterialIcons-Regular.otf": "a6f660ba1f0ca6c3721b7214d8260a35",
"assets/NOTICES": "979f113a77908fc76987d22f03fb3c4d",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"assets/shaders/raymarching.frag": "8c698406e389cab183df1b23a651dc39",
"assets/shaders/raymarching2d.frag": "d91785d10d4d5a110956f23d84ad3008",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/canvaskit.wasm": "73584c1a3367e3eaf757647a8f5c5989",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/chromium/canvaskit.wasm": "143af6ff368f9cd21c863bfa4274c406",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/skwasm.wasm": "2fc47c0a0c3c7af8542b601634fe9674",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "59a12ab9d00ae8f8096fffc417b6e84f",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "e8eebd30e046c78580e8ab125a14a193",
"/": "e8eebd30e046c78580e8ab125a14a193",
"main.dart.js": "535828c8fc326cecc503f221f652089a",
"manifest.json": "50fe8275ab59ecd928536509f6ae0bf8",
"version.json": "baee38dff58cd011e0d7aef7400609ac"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

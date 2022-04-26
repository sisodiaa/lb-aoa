window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}

gtag("js", new Date());

const trackGoogleAnalytics = (event) => {
  const trackingId = document.querySelector("body").dataset.trackingId;

  gtag("config", trackingId, {
    page_location: event.detail.url,
    "cookie_flags": "max-age=7200;secure;samesite=none"
  });
};

document.addEventListener("turbo:load", trackGoogleAnalytics);
document.addEventListener("turbo:visit", trackGoogleAnalytics);

export default gtag;

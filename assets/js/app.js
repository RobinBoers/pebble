import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

function containsFiles(e) {
  return [ ...e.dataTransfer.types ?? [] ].some(t => t == "Files");
}

const Uploads = {
  mounted() {
    this.el.querySelectorAll("input[type='file']").forEach(dropZone => {
      const showDropZone = () => dropZone.style.filter = "brightness(0.95)";
      const hideDropZone = () => dropZone.style.filter = "";

      dropZone.ondragover = e => e.preventDefault();
      dropZone.ondragenter = e => {
        if(containsFiles(e)) showDropZone();
      };

      dropZone.ondragleave = e => hideDropZone();
      dropZone.ondrop = e => hideDropZone();
    });
  }
}

let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: { Uploads },
  metadata: { keydown: (e, _) => ({ ctrl: e.ctrlKey || e.metaKey }) }
});

liveSocket.connect();

// liveSocket.enableDebug();
// liveSocket.enableLatencySim(1000); // enabled for duration of browser session
// liveSocket.disableLatencySim();

window.liveSocket = liveSocket;

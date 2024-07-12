// The MIT License
// 
// Copyright (c) 2023 rekcuFniarB <retratserif@gmail.com>
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// https://github.com/rekcuFniarB/HtmlBoilerplate#readme

(function init() {
    if (!init.scriptDir) {
        let pathParts = document.currentScript.src.split('/');
        pathParts.pop();
        init.scriptDir = pathParts.join('/');
        init.mdScriptSrc = `${init.scriptDir}/markdown-it.min.js`;
    }
    let script = document.querySelector(`script[src^="${init.mdScriptSrc}"]`);
    if (!window.markdownit && !script) {
        script = document.createElement('script');
        script.src = init.mdScriptSrc;
        script.type = 'text/javascript';
        script.init = init;
        script.integrity = 'wLhprpjsmjc/XYIcF+LpMxd8yS1gss6jhevOp6F6zhiIoFK6AmHtm4bGKtehTani';
        script.crossOrigin = 'anonymous';
        document.body.appendChild(script);
        window.addEventListener('load', init);
    }
    init.delay = (init.delay += 100) || 0;
    if (init.delay > 3000) return console.error('ERROR: markdownIt init failed.');
    if (!window.markdownit) return setTimeout(init, init.delay);
    script.markdownIt = script.markdownIt || new markdownit({html: true, linkify: true, typographer: true});
    for (let mdcode of document.querySelectorAll('code.markdown,script[type=\"text/markdown\"]')) {
        if (!mdcode.mdRenderedContent) {
            mdcode.mdRenderedContent = document.createElement('section');
        }
        mdcode.mdRenderedContent.classList.add('markdown-rendered-content');
        mdcode.mdRenderedContent.innerHTML = script.markdownIt.render(mdcode.textContent);
        let wrapper = mdcode.closest('pre') || mdcode;
        wrapper.parentElement.insertBefore(mdcode.mdRenderedContent, wrapper);
        wrapper.style.display = 'none';
        for (let link of mdcode.mdRenderedContent.querySelectorAll('a')) {
            if (link.hostname && link.hostname != document.location.hostname) {
                if (!link.target) {
                    link.target = '_blank';
                }
                if (!link.rel) {
                    link.rel = 'noopener';
                }
            }
        }
    }
    let h1 = document.querySelector('h1');
    if (h1) {
        document.title = h1.textContent;
    }
})();
